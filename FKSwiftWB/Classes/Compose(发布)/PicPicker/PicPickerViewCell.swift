//
//  PicPickerViewCell.swift
//  FKSwiftWB
//
//  Created by kun on 16/8/2.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit

class PicPickerViewCell: UICollectionViewCell {
    // MARK:- 控件的属性
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var removePhotoBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK:- 定义属性
    var image: UIImage? {
        didSet {
            if image != nil {
                imageView.image = image
                addPhotoBtn.userInteractionEnabled = false
                removePhotoBtn.hidden = false
            } else {
                imageView.image = nil
                addPhotoBtn.userInteractionEnabled = true
                removePhotoBtn.hidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    // MARK:- 事件监听
    @IBAction func addPhotoClick() {
        NSNotificationCenter.defaultCenter().postNotificationName(PicPickerAddPhotoNot, object: nil)
    }
    @IBAction func removePhotoClick() {
        NSNotificationCenter.defaultCenter().postNotificationName(PicPickerRemovePhotoNot, object: imageView.image)
    }

}
