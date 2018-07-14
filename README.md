# MySwift
>demo链接-->[https://github.com/PeipeiQ/MySwift](https://github.com/PeipeiQ/MySwift)  
>我的个人博客->[http://www.peipeiq.cn](http://www.peipeiq.cn)
>最近在公司用swift做开发，也开始关注一些swift的语言风格，所以接下来的博客以swift语言为主。oc或者swift有什么问题可以一起交流。
## 一、委托模式
##### 1、使用过程
　　协议最常见的用法莫过于进行代理传值，这就是委托模式。常用的应用场景有：controller中自定义了一个view，view中又添加了一个自定义view。在自定义的view中如果有些函数或者属性需要到controller中去调用，委托模式的做法就是规定一个协议，让controller去遵守一个协议并提供实现，那么在自定义view中就能使用协议中的方法。
　　举个例子，现在想在一个controller中添加一个自定义view，可以实现点击view中按钮更改controller中label的值。简单的代码如下：  
　　自定义view
```
//SelectTabbar.swift
@objc protocol SelectTabbarDelegate {
    func changeLabel(_ str: String)
}
```
```
//SelectTabbar.swift
　class SelectTabbar: UIView {
    var keywords : [String]?
    var buttons : [UIButton]?
    weak public var delegate : SelectTabbarDelegate?

    init(frame: CGRect,keywords:[String]) {
        super.init(frame: frame)
        self.keywords = keywords
        renderView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func renderView(){
        buttons = keywords?.enumerated().map({ (index,key) ->UIButton in
            let buttonWidth = kScreenWidth/CGFloat((keywords?.count)!)
            let button = UIButton.init(frame: CGRect.init(x: CGFloat(index)*buttonWidth, y: 0, width: buttonWidth, height: 50))
            button.setTitle(key, for: .normal)
            button.setTitleColor(UIColor.blue, for: .normal)
            button.backgroundColor = UIColor.gray
            button.tag = index
            button.addTarget(self, action: #selector(tapButton(sender:)), for: .touchUpInside)
            addSubview(button)
            return button
        })
    }
    
    @objc func tapButton(sender: UIButton){
        delegate?.changeLabel(keywords![sender.tag])
    }
    
}
```
　　controller：
```
class TestViewController: UIViewController,SelectTabbarDelegate {
    
    lazy var label : UILabel = {
        var label = UILabel(frame: CGRect.init(x: 50, y: 200, width: 100, height: 30))
        label.text = labelStr
        label.backgroundColor = UIColor.red
        return label
    }()
    
    private var labelStr : String? {
        didSet{
            label.text = labelStr
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(label)
        setupSelectTabbar()
    }
    
    func setupSelectTabbar(){
        let selectTabbar = SelectTabbar(frame: CGRect.init(x: 0, y: kNavigationHeightAndStatuBarHeight, width: kScreenWidth, height: 50),keywords:["aa","bb"])
        selectTabbar.delegate = self
        view.addSubview(selectTabbar)
    }
    
    func changeLabel(_ str: String) {
        labelStr = str
    }

}
```
　　这样就能比较清楚的表明自己的逻辑。否则，如果要在view操作controller的内容，则需要在外部操作controller的实例，这就造成一个问题，就是无法操作实例中的私有属性和私有方法（虽然iOS是一门动态语言，不存在绝对的私有，但是谁会去一直去使用runtime来进行操作呢）。
　　
##### 2、注意点
　　在 ARC 中，对于一般的 delegate，我们会在声明中将其指定为 weak，在这个 delegate 实际的对象被释放的时候，会被重置回 nil。这可以保证即使 delegate 已经不存在时，我们也不会由于访问到已被回收的内存而导致崩溃。ARC 的这个特性杜绝了 Cocoa 开发中一种非常常见的崩溃错误，说是救万千程序员于水火之中也毫不为过。
　　在 Swift 中我们当然也会希望这么做。但是当我们尝试书写这样的代码的时候，编译器不会让我们通过：
```
　　'weak' cannot be applied to non-class type
```
原因：这是因为 Swift 的 protocol 是可以被除了 class 以外的其他类型遵守的，而对于像 struct 或是 enum 这样的类型，本身就不通过引用计数来管理内存，所以也不可能用 weak 这样的 ARC 的概念来进行修饰。
两种解决方法：
1、使用@objc
2、声明类类型专属协议。通过添加 class 关键字来限制协议只能被类类型遵循，而结构体或枚举不能遵循该协议。class 关键字必须第一个出现在协议的继承列表中，在其他继承的协议之前
```protocol SelectTabbarDelegate : class```    
## 二、AOP编程思想的运用

首先我们理解下AOP的含义。
>In computing, aspect-oriented programming (AOP) is a programming paradigm that aims to increase modularity by allowing the separation of cross-cutting concerns. It does so by adding additional behavior to existing code (an advice) without modifying the code itself, instead separately specifying which code is modified via a "pointcut" specification, such as "log all function calls when the function's name begins with 'set'". This allows behaviors that are not central to the business logic (such as logging) to be added to a program without cluttering the code, core to the functionality. AOP forms a basis for aspect-oriented software development.

在swift简单来说，就是利用协议去切入某些代码中，将额外的功能单独出来而不产生耦合，可以将这些与主逻辑关系不大的代码统一放到一起。
常用的场景：日志记录，性能统计，安全控制，事务处理，异常处理等等。
接上面的例子，我们需要在打开TestViewController的时候统计一次，点击两个按钮的时候也进行统计，统计的内容由identifer进行区分。
我们先建立一个```Statistician.swift``` 来存放我们的统计逻辑。（模拟实现）
申明一个StatisticianProtocal协议并提供他的默认实现。
```
import Foundation
enum LogIdentifer:String {
    case button1 = "button1"
    case button2 = "button2"
    case testViewController = "testViewController"
}

protocol StatisticianProtocal {
    func statisticianLog(fromClass:AnyObject, identifer:LogIdentifer)
    func statisticianUpload(fromClass:AnyObject, identifer:LogIdentifer)
    //用一个尾随闭包来扩展功能
    func statisticianExtension(fromClass:AnyObject, identifer:LogIdentifer, extra:()->())
}

extension StatisticianProtocal{
    func statisticianLog(fromClass:AnyObject, identifer:LogIdentifer) {
        print("statisticianLog--class:\(fromClass) from:\(identifer.rawValue)")
    }

    func statisticianUpload(fromClass:AnyObject, identifer:LogIdentifer) {
        print("statisticianUpload--class:\(fromClass) from:\(identifer.rawValue)")
    }
    
    func statisticianExtension(fromClass:AnyObject, identifer:LogIdentifer, extra:()->()){
        extra()
    }
}

class Statistician: NSObject {
    
}
```
接下来在任何需要统计的类里面，我们让这个类去遵守这个协议，然后在需要的地方调用协议中的方法即可。如果在某个特定的类中需要调用的方法略有不同，重写协议中的方法即可。
```
class SelectTabbar: UIView,StatisticianProtocal {
    var keywords : [String]?
    var buttons : [UIButton]?
    weak public var delegate : SelectTabbarDelegate?

    init(frame: CGRect,keywords:[String]) {
        super.init(frame: frame)
        self.keywords = keywords
        renderView()
        //进行一次统计
        operateStatistician(identifer: .testViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func renderView(){
        buttons = keywords?.enumerated().map({ (index,key) ->UIButton in
            let buttonWidth = kScreenWidth/CGFloat((keywords?.count)!)
            let button = UIButton.init(frame: CGRect.init(x: CGFloat(index)*buttonWidth, y: 0, width: buttonWidth, height: 50))
            button.setTitle(key, for: .normal)
            button.setTitleColor(UIColor.blue, for: .normal)
            button.backgroundColor = UIColor.gray
            button.tag = index
            button.addTarget(self, action: #selector(tapButton(sender:)), for: .touchUpInside)
            addSubview(button)
            return button
        })
    }
    
    @objc func tapButton(sender: UIButton){
        //进行一次统计
        switch sender.tag {
          case 0:operateStatistician(identifer: .button1)
          default:operateStatistician(identifer: .button2)
        }
        delegate?.changeLabel(keywords![sender.tag])
    }
    
    func operateStatistician(identifer:LogIdentifer){
        statisticianLog(fromClass: self, identifer: identifer)
        statisticianUpload(fromClass: self, identifer: identifer)
        statisticianExtension(fromClass: self, identifer: identifer) {
            print("extra: in SelectTabbar class")
        }
    }
    
}
```
以上代码实现了三处统计的逻辑，而不用把统计的逻辑写入controller文件中，降低了功能上的耦合度。


## 三、用来代替extension，增强代码可读性
　　使用扩展，可以很方便的为一些继承它的子类增添一些函数。这就带来一个问题，就是所有的子类都拥有了这个方法，但是方法的本身可能不明确，或者是只是想让少数子类来使用这个方法。这时候可以使用协议来代替extension。
```
//定义了一个Shakable协议，遵守这个协议的类即可使用里面的方法，并为该方法提供一个默认的实现
//where Self:UIView表明了只有uiview的子类可以遵守这个协议
protocol Shakable {
    func shakeView()
}

extension Shakable where Self:UIView{
    func shakeView(){
        print(Self.self)
    }
}
```
这时候可以让某个子类来遵守协议。例如刚才上面的例子。
```
class SelectTabbar: UIView,Shakable
```
　　如果不在类中重新实现这个方法，则可以实现默认的方法。这个意思表明，SelectTabbar类的子类是遵守Shakable协议的，间接等于```SelectTabbar():Shakable?```。这样我们就可以愉快的让SelectTabbar对象去使用这个方法。（Self关键字只能用在协议或者类中，表示当前类，可作为返回值使用）。
　　一旦不想让某个子类使用shakeView()方法，很简单，只要把class SelectTabbar: UIView,Shakable中的Shakable协议干掉即可。
　　其他实践：  
　　利用AOP去分离tableview的数据源和事件源的方法，可以单独处理里面的逻辑，使tableview的代理方法不显得那么冗余。  
　　
## 总结
关于协议，还有很多种用法。以上是目前比较常用的场景。日后开发中如果发现协议在其他地方中有更好的应该，将会更新本文。
