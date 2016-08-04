//
//  FoundEmoticon.swift
//  FKSwiftWB
//
//  Created by kun on 16/8/4.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit

class FoundEmoticon: NSObject {
    // MARK:- 设计单例对象
    static let shareInstance: FoundEmoticon = FoundEmoticon()
    // MARK:- 表情属性
    private lazy var manager: EmoticonManager = EmoticonManager()
    
    // 查找属性字符串的方法
    func findAttrString(statusText: String?, font: UIFont) -> NSMutableAttributedString? {
        guard let statusText = statusText else {
            return nil
        }
        // 创建匹配规则
        let pattern = "\\[.*\\]" // 匹配表情
        // 创建正则表达式对席那个
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        // 开始匹配
        let results = regex.matchesInString(statusText, options: [], range: NSRange(location: 0, length: statusText.characters.count))
        // 获取结果
        let attrMStr = NSMutableAttributedString(string: statusText)
        if results.count == 0 {
            return attrMStr
        }
        for index in (results.count - 1)...0 {
            // 获取结果
            let result = results[index]
            // 获取chs
            let chs = (statusText as NSString).substringWithRange(result.range)
            // 根据chs获取图片的路径
            guard let pngPath = findPngPath(chs) else {
                return nil
            }
            // 创建属性字符串
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: pngPath)
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)
            // 将属性字符串替换到来源的文字位置
            attrMStr.replaceCharactersInRange(result.range, withAttributedString: attrImageStr)
        }
        return attrMStr
    }
    private func findPngPath(chs: String) -> String? {
        for package in manager.packages {
            for emoticon in package.emoticons {
                if emoticon.chs == chs {
                    return emoticon.pngPath
                }
            }
        }
        return nil
    }
}
