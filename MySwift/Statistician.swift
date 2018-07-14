//
//  Statistician.swift
//  MySwift
//
//  Created by 沛沛 on 2018/7/14.
//  Copyright © 2018年 peipei. All rights reserved.
//

import Foundation
enum LogIdentifer:String {
    case button1 = "button1"
    case button2 = "button2"
    case testViewController = "testViewController"
}

protocol StatisticianProtocal {
    func statisticianLog(fromClass:AnyObject, identifer:LogIdentifer)
    func statisticianUpload(fromClass:AnyObject, identifer:LogIdentifer)
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


