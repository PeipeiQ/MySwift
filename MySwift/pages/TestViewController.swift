//
//  TestViewController.swift
//  MySwift
//
//  Created by peipei on 2018/5/30.
//  Copyright © 2018年 peipei. All rights reserved.
//

import UIKit

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
        selectTabbar.shakeView()
        view.addSubview(selectTabbar)
    }
    
    func changeLabel(_ str: String) {
        labelStr = str
    }

}
