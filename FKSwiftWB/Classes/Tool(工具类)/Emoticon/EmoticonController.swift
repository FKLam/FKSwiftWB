//
//  EmoticonController.swift
//  FKSwiftWB
//
//  Created by kun on 16/8/2.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit

private let EmoticonCell : String = "EmoticonCell"

class EmoticonController: UIViewController {
    // MARK:- 定义属性
    var emoticonCallBack: (emoticon: Emoticon) -> ()
    // MARK:- 懒加载属性
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: EmoticonCollectionViewLayout())
    private lazy var toolBar: UIToolbar = UIToolbar()
    private lazy var emoticonManager: EmoticonManager = EmoticonManager()
    
    // MARK:- 自定义构造函数
    init(emoticonCallBack: (emoticon: Emoticon) ->()) {
        self.emoticonCallBack = emoticonCallBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

// MARK:- 设置UI界面内容
extension EmoticonController {
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        
        // MARK:- 手写约束，需要设置view的translatesAutoresizingMaskIntoConstraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views = ["toolBar" : toolBar, "collectionView" : collectionView]
        var cons = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-[toolBar]-0-|", options: [.AlignAllLeft, .AlignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        // 准备collectionView
        prepareForCollectionView()
        // 准备toolBar
        prepareForToolBar()
    }
    
    private func prepareForCollectionView() {
        // 注册cell和设置数据源
        collectionView.registerClass(EmoticonViewCell.self, forCellWithReuseIdentifier: EmoticonCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.purpleColor()
    }
    
    private func prepareForToolBar() {
        // 定义toolBar中titles
        let titles = ["最近", "默认", "emoji", "浪小花"]
        
        // 遍历标题，创建item
        var index = 0
        var tempItems = [UIBarButtonItem]()
        for title in titles {
            let item = UIBarButtonItem(title: title, style: .Plain, target: self, action: #selector(EmoticonController.itemClick(_:)))
            item.tag = index
            index += 1
            tempItems.append(item)
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil))
        }
        // 设置toolBar的item数据
        tempItems.removeLast()
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orangeColor()
    }
    
    @objc private func itemClick(item: UIBarButtonItem) {
        // 获取点击的item的tag
        let tag = item.tag
        // 根据tag获取到当前组
        let indexPath = NSIndexPath(forItem: 0, inSection: tag)
        // 滚动到对应的位置
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: true)
        
    }
}

// MARK:- UICollectionView数据源方法和代理方法
extension EmoticonController : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return emoticonManager.packages.count
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = emoticonManager.packages[section]
        return package.emoticons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(EmoticonCell, forIndexPath: indexPath) as! EmoticonViewCell
        let package = emoticonManager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        cell.emoticon = emoticon
        return cell
    }
    // 代理方法
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 取出点击的表情
        let package = emoticonManager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        // 将点击的表情插入最近分组中
        insertRecentlyEmoticon(emoticon)
        emoticonCallBack(emoticon: emoticon)
    }
    
    private func insertRecentlyEmoticon(emoticon: Emoticon) {
        // 过滤空白和删除表情
        if emoticon.isRemove || emoticon.isEmpty {
            return
        }
        // 删除一个表情
        if emoticonManager.packages.first!.emoticons.contains(emoticon) {
            let index = (emoticonManager.packages.first?.emoticons.indexOf(emoticon))!
            emoticonManager.packages.first?.emoticons.removeAtIndex(index)
        } else {
            emoticonManager.packages.first?.emoticons.removeAtIndex(19)
        }
        // 将emoticon插入最近分组中
        emoticonManager.packages.first?.emoticons.insert(emoticon, atIndex: 0)
    }
}

class EmoticonCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        
        // 计算itemWH
        let itemWH = UIScreen.mainScreen().bounds.width / 7.0
        // 设置layout的属性
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .Horizontal
        // 设置collectionView的属性
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        let insetMargin = (collectionView!.bounds.height - 3 * itemWH) / 2.0
        collectionView?.contentInset = UIEdgeInsets(top: insetMargin, left: 0, bottom: insetMargin, right: 0)
    }
}
