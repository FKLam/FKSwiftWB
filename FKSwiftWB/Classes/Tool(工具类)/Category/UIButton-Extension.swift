//
//  UIButton-Extension.swift
//  FKSwiftWB
//
//  Created by kun on 16/7/26.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit

extension UIButton {
    class func createButton(imageName: String, bgImageName: String) -> UIButton {
        let btn = UIButton()
        
        btn.setBackgroundImage(UIImage(named: bgImageName), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), forState: .Highlighted)
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        btn.sizeToFit()
        return btn
    }
    
    convenience init(imageName: String, bgImageName: String) {
        self.init()
        setBackgroundImage(UIImage(named: bgImageName), forState: .Normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), forState: .Highlighted)
        setImage(UIImage(named: imageName), forState: .Normal)
        setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        sizeToFit()
    }
    
    convenience init(bgColor: UIColor, fontSize: CGFloat, title: String) {
        self.init()
        setTitle(title, forState: .Normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
}
