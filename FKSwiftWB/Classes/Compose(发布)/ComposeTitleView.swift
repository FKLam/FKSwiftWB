//
//  ComposeTitleView.swift
//  FKSwiftWB
//
//  Created by kun on 16/8/2.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTitleView: UIView {

    // MARK:- 懒加载控件
    private lazy var titleLabel: UILabel = UILabel()
    private lazy var screenNameLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented" )
    }
}

// MARK:- 设置UI界面
extension ComposeTitleView {
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(screenNameLabel)
        
        titleLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        screenNameLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(titleLabel.snp_centerX)
            make.top.equalTo(titleLabel.snp_bottom).offset(3)
        }
        
        titleLabel.font = UIFont.systemFontOfSize(16)
        screenNameLabel.font = UIFont.systemFontOfSize(14)
        screenNameLabel.textColor = UIColor.lightGrayColor()
        
        titleLabel.text = "发微博"
        screenNameLabel.text = UserAccountViewModel.shareInstance.account?.screen_name
    }
}
