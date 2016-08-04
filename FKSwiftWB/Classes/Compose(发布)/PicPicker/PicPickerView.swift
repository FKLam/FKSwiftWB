//
//  PicPickerView.swift
//  FKSwiftWB
//
//  Created by kun on 16/8/2.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit

private let picPickerCell = "picPickerCell"
private let edgeMargin : CGFloat = 10

class PicPickerView: UICollectionView {
    var images: [UIImage] = [UIImage]() {
        didSet {
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = ( UIScreen.mainScreen().bounds.width - 4 * edgeMargin ) / 3.0
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        
        registerNib(UINib(nibName: "PicPickerViewCell", bundle: nil), forCellWithReuseIdentifier: picPickerCell)
        dataSource = self
        
        // 设置collectionView的内边距
        contentInset = UIEdgeInsets(top: edgeMargin, left: edgeMargin, bottom: 0, right: edgeMargin)
    }
}

extension PicPickerView : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(picPickerCell, forIndexPath: indexPath) as! PicPickerViewCell
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
        return cell
    }
}
