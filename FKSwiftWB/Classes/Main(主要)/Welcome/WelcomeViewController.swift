//
//  WelcomeViewController.swift
//  FKSwiftWB
//
//  Created by kun on 16/7/31.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    // MARK:- 拖线的属性
    @IBOutlet weak var iconViewBottonCons: NSLayoutConstraint!
    @IBOutlet weak var iconView: UIImageView!
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileURLString = UserAccountViewModel.shareInstance.account?.avatar_large
        // ??
        let url = NSURL(string: profileURLString ?? "")
        // 设置头像
        iconView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "avatar_default_big"))
        // 改变约束的值
        iconViewBottonCons.constant = UIScreen.mainScreen().bounds.height - 200
        // 执行动画
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: [], animations: {
                self.view.layoutSubviews()
            }) { (_) in
                UIApplication.sharedApplication().keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }

}
