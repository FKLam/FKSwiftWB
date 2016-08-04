//
//  PhotoBrowserController.swift
//  FKSwiftWB
//
//  Created by kun on 16/8/4.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

private let PhotoBrowserCell: String = "PhotoBrowserCell"

class PhotoBrowserController: UIViewController {
    // MARK:- 定义属性
    var indexPath: NSIndexPath
    var picURLs: [NSURL]
    // MARK:- 懒加载属性
    private lazy var collectionView: UICollectionView = {
       var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: PhotoBrowserCollectionViewLayout())
        collectionView.frame = self.view.bounds
        collectionView.registerClass(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCell)
        collectionView.dataSource = self
        return collectionView
    }()
    private lazy var closeBtn: UIButton = {
        var closeBtn = UIButton(bgColor: UIColor.darkGrayColor(), fontSize: 14, title: "关闭")
        closeBtn.addTarget(self, action: #selector(PhotoBrowserController.closeBtnClick), forControlEvents: .TouchUpInside)
        return closeBtn
    }()
    private lazy var saveBtn: UIButton = {
        var saveBtn = UIButton(bgColor: UIColor.darkGrayColor(), fontSize: 14, title: "保存")
        saveBtn.addTarget(self, action: #selector(PhotoBrowserController.saveBtnClick), forControlEvents: .TouchUpInside)
        return saveBtn
    }()
    // MARK:- 自定义构造函数
    init(indexPath: NSIndexPath, picURLs: [NSURL]) {
        self.indexPath = indexPath
        self.picURLs = picURLs
        super.init(nibName: nil, bundle: nil)
    }
    // MARK:- 系统回调函数
    override func loadView() {
        super.loadView()
        view.frame.size.width += 20
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        // 滚动到对应的图片
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
    }

}

// MARK:- 设置UI界面
extension PhotoBrowserController {
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        // 设置frame
        closeBtn.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        saveBtn.snp_makeConstraints { (make) in
            make.right.equalTo(-40)
            make.bottom.equalTo(closeBtn.snp_bottom)
            make.size.equalTo(closeBtn.snp_size)
        }
    }
}

// MARK:- 实现collectionView的数据源方法
extension PhotoBrowserController : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserCell, forIndexPath: indexPath) as! PhotoBrowserViewCell
        cell.picURL = picURLs[indexPath.item]
        cell.delegate = self
        return cell
    }
}

// MARK:- 自定义collectionViewLayout
class PhotoBrowserCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        
        // 设置itemSize
        itemSize = collectionView!.frame.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .Horizontal
        // 设置collectionView的属性
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}

// MARK:- 事件监听函数
extension PhotoBrowserController {
    @objc private func closeBtnClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @objc private func saveBtnClick() {
        // 获取当前正在显示的image
        let cell = collectionView.visibleCells().first as! PhotoBrowserViewCell
        guard let image = cell.imageView.image else {
            return
        }
        // 将image对象保存相册,按照系统提供的方法格式写监听方法
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowserController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc private func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        var showInfo = ""
        if didFinishSavingWithError != nil {
            showInfo = "保存失败"
        } else {
            showInfo = "保存成功"
        }
        SVProgressHUD.showInfoWithStatus(showInfo)
    }
}

// MARK:- PhotoBrowserViewCellDelegae代理方法
extension PhotoBrowserController: PhotoBrowserViewCellDelegate {
    func imageViewClick() {
        closeBtnClick()
    }
}

// MARK:- AnimatorDismissDelegate方法
extension PhotoBrowserController: AnimatorDismissDelegate {
    func indexPathForDismiss() -> NSIndexPath {
        // 获取当前正在显示的indexPath
        let cell = collectionView.visibleCells().first!
        return collectionView.indexPathForCell(cell)!
    }
    
    func imageViewForDismiss() -> UIImageView {
        // 创建imageView
        let imageView = UIImageView()
        // 设置imageView的frame
        let cell = collectionView.visibleCells().first as! PhotoBrowserViewCell
        imageView.frame = cell.imageView.frame
        imageView.image = cell.imageView.image
        // 设置imageView的属性
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
}