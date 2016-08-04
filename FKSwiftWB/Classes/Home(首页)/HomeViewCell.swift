//
//  HomeViewCell.swift
//  FKSwiftWB
//
//  Created by kun on 16/8/1.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit
import SDWebImage
import HYLabel

private let edgeMargin: CGFloat = 15.0
private let itemMargin: CGFloat = 10.0

class HomeViewCell: UITableViewCell {
    // MARK:-   控件属性
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: HYLabel!
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    @IBOutlet weak var picViewHCons: NSLayoutConstraint!
    @IBOutlet weak var picView: PicCollectionView!
    @IBOutlet weak var retweetedContentLabel: HYLabel!
    @IBOutlet weak var retweetedBackgroundView: UIView!
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var retweetedContentTopCons: NSLayoutConstraint!
    @IBOutlet weak var bottomToolView: UIView!
    
    // MARK:- 约束的属性
    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    
    // MARK:- 自定义属性
    var viewModel: StatusViewModel? {
        didSet {
            // nil值校验
            guard let viewModel = viewModel else {
                return
            }
            
            // 设置头像
            iconView.sd_setImageWithURL(viewModel.profileURL, placeholderImage: UIImage(named: "avatar_default_small"))
            
            // 设置认证的图标
            verifiedView.image = viewModel.verifiedImage
            
            // 昵称
            screenNameLabel.text = viewModel.status?.user?.screen_name
            
            // 会员图标
            vipView.image = viewModel.vipImage
            
            // 设置时间的label
            timeLabel.text = viewModel.createAtText
            
            // 设置来源
            if let sourceText = viewModel.sourceText {
                sourceLabel.text = "来自 " + sourceText
            } else {
                sourceLabel.text = nil
            }
            
            // 设置内容
            contentLabel.attributedText = FoundEmoticon.shareInstance.findAttrString(viewModel.status?.text, font: contentLabel.font)
            
            // 设置昵称的文字颜色
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.blackColor() : UIColor.orangeColor()
            
            // 计算picView的宽高的约束
            let picViewSize = calculatePivViewSize(viewModel.picURLs.count)
            picViewWCons.constant = picViewSize.width
            picViewHCons.constant = picViewSize.height
            
            // 将picURL传递给picView
            picView.picURLs = viewModel.picURLs
            
            // 设置转发微博的数据
            if viewModel.status?.retweeted_status != nil {
                // 设置转发微博的正文
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name, retweetedText = viewModel.status?.retweeted_status?.text {
                    let reweetedStatusText = "@" + "\(screenName):" + retweetedText
                    retweetedContentLabel.attributedText = FoundEmoticon.shareInstance.findAttrString(reweetedStatusText, font: retweetedContentLabel.font)
                    retweetedContentTopCons.constant = 15
                }
                // 设置背景显示
                retweetedBackgroundView.hidden = false
            }
            else {
                retweetedContentLabel.text = nil
                retweetedBackgroundView.hidden = true
                retweetedContentTopCons.constant = 0
            }
            
            // 计算cell的高度
            if viewModel.cellHeight == 0 {
                layoutIfNeeded()
                viewModel.cellHeight = CGRectGetMaxY(bottomToolView.frame)
            }
        }
    }
    
    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置微博正文的宽度约束
        contentLabelWCons.constant = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
        // 监听@谁谁谁的点击
        contentLabel.userTapHandler = { (label, user, range) in
            print(user)
            print(range)
        }
        
        // 监听链接的点击
        contentLabel.linkTapHandler = { (label, link, range) in
            print(link)
            print(range)
        }
        
        // 监听话题的点击
        contentLabel.topicTapHandler = { (label, topic, range) in
            print(topic)
            print(range)
        }
    }
}

// MARK:- 计算方法
extension HomeViewCell {
    private func calculatePivViewSize(count: Int) -> CGSize {
        // 没有配图
        if count == 0 {
            picViewBottomCons.constant = 0
            return CGSizeZero
        }
        
        picViewBottomCons.constant = 10
        
        // 取出picView对应的layout
        let layout = picView.collectionViewLayout as? UICollectionViewFlowLayout
        // 单张配图
        if count == 1 {
            // 取出图片
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(viewModel?.picURLs.last?.absoluteString)
            // 设置一张图片时layout的itemSize
            layout?.itemSize = CGSize(width: image.size.width * 2, height: image.size.height * 2)
            return layout!.itemSize
        }
        
        // 计算出来imageViewWH
        let imageWH = (UIScreen.mainScreen().bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3.0
        
        // 设置其他张数的layout的itemSize
        layout?.itemSize = CGSize(width: imageWH, height: imageWH)
        
        // 四张配图
        if count == 4 {
            let picViewWH = imageWH * 2 + itemMargin
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        // 其他张数配图
        // 计算行数
        let rows = CGFloat((count - 1) / 3 + 1)
        
        // 计算picView的高度
        let picViewH = rows * imageWH + (rows - 1) * itemMargin
        
        // 计算picView的宽度
        let picViewW = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
        
        return CGSize(width: picViewW, height: picViewH)
    }
}
