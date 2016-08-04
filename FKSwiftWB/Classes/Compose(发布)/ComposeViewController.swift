//
//  ComposeViewController.swift
//  FKSwiftWB
//
//  Created by kun on 16/8/2.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {
    // MARK:- 懒加载属性
    private lazy var titleView: ComposeTitleView = ComposeTitleView()
    private lazy var images: [UIImage] = [UIImage]()
    private lazy var emoticonVc: EmoticonController = EmoticonController {[weak self] (emoticon) in
        self?.textView.insertEmoticon(emoticon)
        self?.textViewDidChange(self!.textView)
    }
    
    // MARK:- 控件
    @IBOutlet weak var textView: ComposeTextView!
    @IBOutlet weak var picPickerView: PicPickerView!
    
    // MARK:- 约束的属性
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    @IBOutlet weak var picPickerHeightCons: NSLayoutConstraint!
    
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNativgationBar()
        
        // 监听通知
        setupNotifications()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        textView.resignFirstResponder()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

// MARK:- 设置UI界面
extension ComposeViewController {
    private func setupNativgationBar() {
        // 设置左右的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(ComposeViewController.closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: #selector(ComposeViewController.sendItemClick))
        navigationItem.rightBarButtonItem?.enabled = false
        
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
    
    private func setupNotifications() {
        // 监听键盘弹
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.keyboardWillChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        // 监听添加照片
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.picPickerAddPhotoClick), name: PicPickerAddPhotoNot, object: nil)
        // 监听添加照片
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.picPickerRemovePhotoClick(_:)), name: PicPickerRemovePhotoNot, object: nil)
        
    }
}

// MARK:- 事件监听函数
extension ComposeViewController {
    @objc private func closeItemClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func sendItemClick() {
        SVProgressHUD.showWithStatus("发送中...")
        // 退出键盘
        textView.resignFirstResponder()
        // 获取发送微博的正文
        let statusText = textView.getEmoticonString()
        // 定义回调闭包
        let finishedCallback = { (isSuccess: Bool) -> () in
            if !isSuccess {
                SVProgressHUD.showErrorWithStatus("发送微博失败")
                return
            }
            SVProgressHUD.showSuccessWithStatus("发送微博成功")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        // 获取配图
        if let image = images.first {
            NetworkingTools.shareInstance.sendStatus(statusText, image: image, sendResult: finishedCallback)
        } else {
            // 调用接口发送微博
            NetworkingTools.shareInstance.sendStatus(statusText, sendResult: finishedCallback)
        }
    }
    
    @objc private func keyboardWillChangeFrame(not: NSNotification) {
        let duration = not.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        
        let endFrame = (not.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let y = endFrame.origin.y
        
        let margin = UIScreen.mainScreen().bounds.height - y
        
        toolBarBottomCons.constant = margin
        UIView.animateWithDuration(duration) { 
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func picPickerBtnClick() {
        textView.resignFirstResponder()
        
        picPickerHeightCons.constant = UIScreen.mainScreen().bounds.height * 0.65
        UIView.animateWithDuration(0.5) { 
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func emoticonBtnClick() {
        // 退出键盘
        textView.resignFirstResponder()
        
        // 切换键盘
//        textView.inputView = textView.inputView != nil ? nil : emoticonVc.view
        textView.inputView = emoticonVc.view
        
        // 弹出键盘
        textView.becomeFirstResponder()
    }
    
    @objc private func picPickerAddPhotoClick() {
        // 判断照片源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            return
        }
        // 创建照片选择控制器
        let ipc = UIImagePickerController()
        // 设置照片源
        ipc.sourceType = .PhotoLibrary
        ipc.delegate = self
        presentViewController(ipc, animated: true) { 
            
        }
    }
    
    @objc private func picPickerRemovePhotoClick(not: NSNotification) {
        guard let image = not.object as? UIImage else {
            return
        }
        
        guard let index = images.indexOf(image) else {
            return
        }
        images.removeAtIndex(index)
        picPickerView.images = images
    }
}

// MARK:- UITextViewDelegate方法
extension ComposeViewController : UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        self.textView.placeHolderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}

// MARK:- UIImagePickerController代理的方法的方法
extension ComposeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // 获取选中的照片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        images.append(image)
        picPickerView.images = images
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
