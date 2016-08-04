//
//  EmoticonViewCell.swift
//  FKSwiftWB
//
//  Created by kun on 16/8/3.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {
    // MARK:- 懒加载
    private lazy var emoticonBtn: UIButton = UIButton()
    
    // MARK:- 定义属性
    var emoticon: Emoticon? {
        didSet {
            guard let emoticon = emoticon else {
                return
            }
            emoticonBtn.setImage(UIImage(contentsOfFile: emoticon.pngPath ?? ""), forState: .Normal)
            emoticonBtn.setTitle(emoticon.emojiCode, forState: .Normal)
            // 设置删除按钮
            if emoticon.isRemove {
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), forState: .Normal)
            }
        }
    }
    
    // MARK:- 重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI界面内容
extension EmoticonViewCell {
    private func setupUI() {
        contentView.addSubview(emoticonBtn)
        emoticonBtn.frame = contentView.bounds
        emoticonBtn.userInteractionEnabled = false
        emoticonBtn.titleLabel?.font = UIFont.systemFontOfSize(32)
    }
}
