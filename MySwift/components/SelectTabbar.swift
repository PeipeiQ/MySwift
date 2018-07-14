//
//  SelectTabbar.swift
//  MySwift
//
//  Created by peipei on 2018/5/30.
//  Copyright © 2018年 peipei. All rights reserved.
//

import UIKit

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

@objc protocol SelectTabbarDelegate {
    func changeLabel(_ str: String)
}

class SelectTabbar: UIView,Shakable,StatisticianProtocal {
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
