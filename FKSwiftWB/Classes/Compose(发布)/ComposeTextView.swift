//
//  ComposeTextView.swift
//  FKSwiftWB
//
//  Created by kun on 16/8/2.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTextView: UITextView {
    // MARK:- 懒加载属性
    lazy var placeHolderLabel: UILabel = UILabel()
    
    // 如果一个控件是从xib里创建的，先执行这个方法（添加子控件）
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    // 再执行这个方法（控件初始化）
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

// MARK:- 设置UI界面
extension ComposeTextView {
    private func setupUI() {
        addSubview(placeHolderLabel)
        
        placeHolderLabel.snp_makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        
        placeHolderLabel.textColor = UIColor.lightGrayColor()
        placeHolderLabel.font = font
        
        placeHolderLabel.text = "分享新鲜事..."
        
        textContainerInset = UIEdgeInsets(top: 7, left: 7, bottom: 0, right: 7)
    }
}
