//
//  SelectTabbar.swift
//  MySwift
//
//  Created by peipei on 2018/5/30.
//  Copyright © 2018年 peipei. All rights reserved.
//

import UIKit

class SelectTabbar: UIView {
    var keywords : [String]?
    var buttons : [UIButton]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.init(hexString: "eeeeee")
        
    }
    
    convenience init(frame: CGRect,keywords:[String]) {
        self.init(frame: frame)
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
            button.backgroundColor = .blue
            addSubview(button)
            return button
        })
        print(buttons!)
    }

}
