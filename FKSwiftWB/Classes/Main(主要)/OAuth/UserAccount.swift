//
//  UserAccount.swift
//  FKSwiftWB
//
//  Created by kun on 16/7/29.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    // MARK:- 属性
    // 用户授权的唯一票据，用于调用微博的开放接口，同时也是第三方应用验证微博用户登录的唯一票据，第三方应用应该用该票据和自己应用内的用户建立唯一影射关系，来识别登录状态，不能使用本返回值里的UID字段来做登录识别
    var access_token: String?
    
    // access_token的生命周期，单位是秒数。
    var expires_in: NSTimeInterval = 0.0 {
        didSet {
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    
    // 授权用户的UID，本字段只是为了方便开发者，减少一次user/show接口调用而返回的，第三方应用不能用此字段作为用户登录状态的识别，只有access_token才是用户授权的唯一票据。
    var uid: String?
    
    // 过期日期
    var expires_date: NSDate?
    
    // 昵称
    var screen_name: String?
    
    // 用户的头像地址
    var avatar_large: String?

    // MARK:- 自定义构造函数
    init(dict: [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    // MARK:- 重写description的属性
    override var description: String {
        return dictionaryWithValuesForKeys(["access_token", "expires_in", "uid", "expires_date", "screen_name", "avatar_large"]).description
    }
    
    // MARK:- 归档&解档
    // 解档的方法
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
    }
    
    // 归档的方法
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
    }
}
