//
//  UIBarButtonItem-Extension.swift
//  FKSwiftWB
//
//  Created by kun on 16/7/28.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(imageName : String) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        btn.sizeToFit()
        
        self.init(customView : btn)
    }
}
