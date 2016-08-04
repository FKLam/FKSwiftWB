//
//  PhotoBrowserAnimator.swift
//  FKSwiftWB
//
//  Created by kun on 16/8/4.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit

// 面向协议开发
protocol AnimatorPresentedDelegate: NSObjectProtocol {
    func startRect(indexPath: NSIndexPath) -> CGRect
    func endRect(indexPath: NSIndexPath) -> CGRect
    func imageView(indexPath: NSIndexPath) -> UIImageView
}

protocol AnimatorDismissDelegate: NSObjectProtocol {
    func indexPathForDismiss() -> NSIndexPath
    func imageViewForDismiss() -> UIImageView
}

class PhotoBrowserAnimator: NSObject {
    private var isPresented: Bool = false
    var presentedDelegate: AnimatorPresentedDelegate?
    var dismissDelegate: AnimatorDismissDelegate?
    var indexPath: NSIndexPath?
}

// MARK:- 
extension PhotoBrowserAnimator: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

extension PhotoBrowserAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext) : animationForDismissView(transitionContext)
    }
    private func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        // nil值校验
        guard let presentedDelegate = presentedDelegate, indexPath = indexPath else {
            return
        }
        // 取出弹出的View
        let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        // 将presentedView添加到containerView中
        transitionContext.containerView()?.addSubview(presentedView)
        // 获取执行动画的imageView
        let startRect = presentedDelegate.startRect(indexPath)
        let imageView = presentedDelegate.imageView(indexPath)
        imageView.frame = startRect
        transitionContext.containerView()?.addSubview(imageView)
        // 执行动画
        presentedView.alpha = 0.0
        transitionContext.containerView()?.backgroundColor = UIColor.blackColor()
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            imageView.frame = presentedDelegate.endRect(indexPath)
        }) { (_) in
            presentedView.alpha = 1.0
            imageView.removeFromSuperview()
            transitionContext.containerView()?.backgroundColor = UIColor.clearColor()
            transitionContext.completeTransition(true)
        }
    }
    private func animationForDismissView(transitionContext: UIViewControllerContextTransitioning) {
        // nil值校验
        guard let dismissDelegate = dismissDelegate, presentedDelegate = presentedDelegate else {
            return
        }
        // 取出消失的View
        let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        dismissView.removeFromSuperview()
        // 获取执行动画的imageView
        let imageView = dismissDelegate.imageViewForDismiss()
        let indexPath = dismissDelegate.indexPathForDismiss()
        transitionContext.containerView()?.addSubview(imageView)
        transitionContext.containerView()?.backgroundColor = UIColor.blackColor()
        // 执行动画
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            imageView.frame = presentedDelegate.startRect(indexPath)
            transitionContext.containerView()?.backgroundColor = UIColor.clearColor()
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}