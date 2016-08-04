//
//  PopoverAnimator.swift
//  FKSwiftWB
//
//  Created by kun on 16/7/28.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {
    
    // MARK:- 属性
    var isPresented : Bool = false
    var presentFrame : CGRect = CGRectZero
    
    var callBack : ((presented : Bool) -> ())?
    
    // MARK:- 自定义构造函数
    init(callBack : (presented : Bool) -> ()) {
        self.callBack = callBack
    }
}

// MARK:- 自定义转场代理的方法
extension PopoverAnimator : UIViewControllerTransitioningDelegate {
    // 目的改变弹出View的尺寸
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let presentView = FKPresentationController(presentedViewController: presented, presentingViewController: presenting)
        presentView.presentFrame = presentFrame
        return presentView
    }
    
    // 目的自定义弹出的动画
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        callBack!(presented : isPresented)
        return self
    }
    
    // 目的自定义消失的动画
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        callBack!(presented : isPresented)
        return self
    }
}

// MARK:- 弹出和消失动画代理的方法
extension PopoverAnimator : UIViewControllerAnimatedTransitioning {
    // 动画执行的时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    // 获取“转场的上下文”可以通过转场上下文获取弹出的View和消失的View
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext) : animationForDismissView(transitionContext)
    }
    
    // 自定义弹出动画
    private func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        // 获取弹出的View
        let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // 将弹出的View添加到containerView中
        transitionContext.containerView()?.addSubview(presentedView)
        
        // 执行动画
        presentedView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        presentedView.layer.anchorPoint = CGPointMake(0.5, 0)
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            presentedView.transform = CGAffineTransformIdentity
        }) { (_) in
            // 必须通知转场上下文已经完成动画
            transitionContext.completeTransition(true)
        }
    }
    
    // 自定义消失动画
    private func animationForDismissView(transitionContext: UIViewControllerContextTransitioning) {
        // 获取弹出的View
        let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        // 执行动画
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            //            dismissView.transform = CGAffineTransformMakeScale(1.0, 0.0)
            dismissView.alpha = 0.0
        }) { (_) in
            dismissView.removeFromSuperview()
            // 必须通知转场上下文已经完成动画
            transitionContext.completeTransition(true)
        }
    }
}
