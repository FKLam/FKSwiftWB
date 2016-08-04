//
//  FKPresentationController.swift
//  FKSwiftWB
//
//  Created by kun on 16/7/28.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit

class FKPresentationController: UIPresentationController {
    
    var presentFrame : CGRect = CGRectZero
    // MARK:- 懒加载属性
    private lazy var converView : UIView = UIView()
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        // 设置弹出view的尺寸
        presentedView()?.frame = presentFrame
        
        // 添加蒙板
        setupConverView()
    }
}

// MARK:- 设置UI界面相关
extension FKPresentationController {
    private func setupConverView() {
        // 添加蒙板
        containerView?.insertSubview(converView, atIndex: 0)
        
        // 设置蒙板的属性
        converView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        converView.frame = containerView!.bounds
        
        // 添加手势
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(FKPresentationController.converViewClick))
        converView.addGestureRecognizer(tapGes)
    }
}

// MARK:- 事件监听
extension FKPresentationController {
    @objc private func converViewClick() {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
