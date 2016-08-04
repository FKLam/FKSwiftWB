//
//  EmoticonManager.swift
//  FKSwiftWB
//
//  Created by kun on 16/8/3.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit

class EmoticonManager {
    var packages: [EmoticonPackage] = [EmoticonPackage]()
    
    init() {
        // 添加最近表情的包
        packages.append(EmoticonPackage(id: ""))
        
        // 添加默认表情的包
        packages.append(EmoticonPackage(id: "com.apple.emoji"))
        
        // 添加emoji表情的包
        packages.append(EmoticonPackage(id: "com.sina.default"))
        
        // 添加浪小花表情的包
        packages.append(EmoticonPackage(id: "com.sina.lxh"))
        
    }
}
