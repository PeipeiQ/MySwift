//
//  ViewController.swift
//  MySwift
//
//  Created by peipei on 2018/5/30.
//  Copyright © 2018年 peipei. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    let tableView : UITableView? = nil
    let pages = ["NetworkController","FriendCircleController","TestViewController"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white;
        renderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func renderView() {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: 375, height: 667), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = pages[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //命名空间
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"]as! String
        let clsName = namespace + "." + pages[indexPath.item]
        let cls = NSClassFromString(clsName) as! UIViewController.Type
        let vc = cls.init()
        navigationController?.pushViewController(vc, animated: true)
    }

}


