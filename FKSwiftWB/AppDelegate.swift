//
//  AppDelegate.swift
//  FKSwiftWB
//
//  Created by kun on 16/7/24.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var defaultViewController: UIViewController? {
        let isLogin = UserAccountViewModel.shareInstance.isLogin
        return isLogin ? WelcomeViewController() : UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 设置全局Navigation显示的颜色
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        
        // 设置全局tabBar显示的颜色
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        // 创建window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = defaultViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

