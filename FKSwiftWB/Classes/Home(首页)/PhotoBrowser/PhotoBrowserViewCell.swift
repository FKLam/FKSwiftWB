//
//  PhotoBrowserViewCell.swift
//  FKSwiftWB
//
//  Created by kun on 16/8/4.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit
import SDWebImage

@objc protocol PhotoBrowserViewCellDelegate: NSObjectProtocol {
    optional func imageViewClick()
}

class PhotoBrowserViewCell: UICollectionViewCell {
    // MARK:- 懒加载属性
    private lazy var scrollView: UIScrollView = {
       var scrollView = UIScrollView()
        scrollView.frame = self.contentView.bounds
        scrollView.frame.size.width -= 20
        return scrollView
    }()
    lazy var imageView: UIImageView = {
        var imageView: UIImageView = UIImageView();
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowserViewCell.imageViewClick))
        imageView.addGestureRecognizer(tapGes)
        imageView.userInteractionEnabled = true
        return imageView
    }()
    private lazy var progressView: ProgressView = {
        var progressView = ProgressView()
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.mainScreen().bounds.width * 0.5, y: UIScreen.mainScreen().bounds.height * 0.5)
        progressView.hidden = true
        progressView.backgroundColor = UIColor.clearColor()
        
        return progressView
    }()
    var delegate: PhotoBrowserViewCellDelegate?
    // MARK:- 定义属性
    var picURL: NSURL? {
        didSet {
            setupContent(picURL)
        }
    }
    
    // MARK:- 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI界面内容
extension PhotoBrowserViewCell {
    private func setupUI() {
        contentView.addSubview(scrollView)
        contentView.addSubview(imageView)
        contentView.addSubview(progressView)
    }
}

// MARK:- 设置Cell的内容
extension PhotoBrowserViewCell {
    private func setupContent(picURL: NSURL?) {
        // nil值校验
        guard let picURL = picURL else {
            return
        }
        
        // 取出image对象
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picURL.absoluteString)
        // 计算imageView的frame
        let x: CGFloat = 0
        let width = UIScreen.mainScreen().bounds.width
        let height = width / image.size.width * image.size.height
        var y: CGFloat = 0
        if height > UIScreen.mainScreen().bounds.height {
            y = 0
        } else {
            y = (UIScreen.mainScreen().bounds.height - height) * 0.5
        }
        progressView.hidden = false
        imageView.frame = CGRect(x: x, y: y, width: width, height: height)
        // 设置图片
        imageView.sd_setImageWithURL(getBigURLString(picURL), placeholderImage: image, options: [], progress: { (current, total) in
            self.progressView.progress = CGFloat(current) / CGFloat(total)
            }) { (_, _, _, _) in
                self.progressView.hidden = true
        }
        // 设置scrollView的contentSize
        scrollView.contentSize = CGSize(width: 0, height: height)
    }
    private func getBigURLString(smallURL: NSURL) -> NSURL {
        let smallURLString = smallURL.absoluteString
        let bigURLString = smallURLString.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
        return NSURL(string: bigURLString)!
    }
}

// MARK:- 事件监听
extension PhotoBrowserViewCell {
    @objc private func imageViewClick() {
        delegate?.imageViewClick!()
    }
}
