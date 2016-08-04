//
//  PicCollectionView.swift
//  FKSwiftWB
//
//  Created by kun on 16/8/2.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit
import SDWebImage

class PicCollectionView: UICollectionView {
    // MARK:- 定义属性
    var picURLs: [NSURL] = [NSURL]() {
        didSet {
            self.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
        delegate = self
    }
}

// MARK:- collectionView的数据源方法
extension PicCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PicCell", forIndexPath: indexPath) as! PicCollectionViewCell
        
        cell.picURL = picURLs[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 获取通知需要传递的参数
        let userInfo = [ShowPhotoBrowserIndexKey : indexPath, ShowPhotoBrowserUrlKey : picURLs]
        // 发出通知
        NSNotificationCenter.defaultCenter().postNotificationName(ShowPhotoBrowserNot, object: self, userInfo: userInfo)
    }
}

class PicCollectionViewCell: UICollectionViewCell {
    // MARK:- 定义模型属性
    var picURL: NSURL? {
        didSet {
            guard let picURL = picURL else {
                return
            }
            iconView.sd_setImageWithURL(picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    // MARK:- 控件属性
    @IBOutlet weak var iconView: UIImageView!
}

// MARK:- AnimatorPresentedDelegate
extension PicCollectionView: AnimatorPresentedDelegate {
    func startRect(indexPath: NSIndexPath) -> CGRect {
        // 获取cell
        let cell = self.cellForItemAtIndexPath(indexPath)!
        // 获取cell的frame
        let startFrame = self.convertRect(cell.frame, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
        return startFrame
    }
    
    func endRect(indexPath: NSIndexPath) -> CGRect {
        // 获取该位置的image对象
        let picURL = picURLs[indexPath.item]
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picURL.absoluteString)
        // 计算结束后的frame
        let w = UIScreen.mainScreen().bounds.width
        let h = w / image.size.width * image.size.height
        var y: CGFloat = 0
        if h > UIScreen.mainScreen().bounds.height {
            y = 0
        } else {
            y = (UIScreen.mainScreen().bounds.height - h) * 0.5
        }
        return CGRect(x: 0, y: y, width: w, height: h)
    }
    
    func imageView(indexPath: NSIndexPath) -> UIImageView {
        // 创建UIImageView对象
        let imageView = UIImageView()
        // 获取该位置的image对象
        let picURL = picURLs[indexPath.item]
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picURL.absoluteString)
        imageView.image = image
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
}
