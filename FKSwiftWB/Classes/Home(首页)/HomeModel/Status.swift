//
//  Status.swift
//  FKSwiftWB
//
//  Created by kun on 16/8/1.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit

class Status: NSObject {
    // MARK:- 属性
    var created_at: String?             // 微博创建时间
    var source: String?                 // 微博来源
    var text: String?                   // 微博的正文
    var mid: Int = 0                    // 微博的ID
    var user: User?                     // 微博对应的用户
    var pic_urls: [[String : String]]?  // 微博的配图
    var retweeted_status: Status?  // 微博对应的转发的微博
    
    // MARK:- 自定义构造函数
    init(dict: [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        
        // 将用户字典转为用户模型对象
        if let userDict = dict["user"] as? [String : AnyObject] {
            user = User(dict: userDict)
        }
        
        // 将转发微博字典转成微博模型对象
        if let retweetedStatusDict = dict["retweeted_status"] as? [String : AnyObject] {
            retweeted_status = Status(dict: retweetedStatusDict)
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
