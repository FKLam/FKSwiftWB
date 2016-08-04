//
//  VisitorView.swift
//  FKSwiftWB
//
//  Created by kun on 16/7/27.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit

class VisitorView: UIView {
    
    // MARK:- 提供快速通过xib创建的类方法
    class func visitorView() -> VisitorView {
        return NSBundle.mainBundle().loadNibNamed("VisitorView", owner: nil, options: nil).first as! VisitorView
    }
    
    // MARK:- 控件属性
    @IBOutlet weak var rotaterView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    // MARK:- 自定义函数
    func setupVisitorViewInfo(iconName: String, title: String) {
        iconView.image = UIImage(named: iconName)
        tipLabel.text = title
        rotaterView.hidden = true
    }
    
    func addRotationAnim() {
        // 创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        // 设置动画的属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = M_PI * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 5
        rotationAnim.removedOnCompletion = false
        
        // 将动画添加到layer中
        rotaterView.layer.addAnimation(rotationAnim, forKey: nil)
    }
}
