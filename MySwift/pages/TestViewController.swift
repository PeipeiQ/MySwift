//
//  TestViewController.swift
//  MySwift
//
//  Created by peipei on 2018/5/30.
//  Copyright © 2018年 peipei. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSelectTabbar()
    }
    
    func setupSelectTabbar(){
        let selectTabbar = SelectTabbar.init(frame: CGRect.init(x: 0, y: kNavigationHeightAndStatuBarHeight, width: kScreenWidth, height: 50),keywords:["aa","bb"])
        view.addSubview(selectTabbar)
    }


}
