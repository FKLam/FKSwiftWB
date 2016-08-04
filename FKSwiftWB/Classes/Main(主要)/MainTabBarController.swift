//
//  MainTabBarController.swift
//  FKSwiftWB
//
//  Created by kun on 16/7/24.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK:- 懒加载属性
    private lazy var imageNames = ["tabbar_home", "tabbar_message_center", "", "tabbar_discover", "tabbar_profile"]
//    private lazy var composeBtn : UIButton = UIButton.createButton("tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    private lazy var composeBtn : UIButton = UIButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComposeBtn()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupTabbarItems()
    }
    
    private func setupChildVc() {
        // 获取json文件路径
        guard  let jsonPath = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil) else {
            return
        }
        // 读取json文件的内容
        guard let jsonData = NSData(contentsOfFile: jsonPath) else {
            return
        }
        // 将Data转成数组
        guard let anyObject = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) else {
            return
        }
        guard let dictArray = anyObject as? [[String : AnyObject]] else {
            return
        }
        // 遍历字典，获取对应的信心
        for dict in dictArray {
            guard let vcName = dict["vcName"] as? String else {
                continue
            }
            guard let title = dict["title"] as? String else {
                continue
            }
            guard let imageName = dict["imageName"] as? String else {
                continue
            }
            addChildViewController(vcName, title: title, imageName: imageName)
            
        }
        //        addChildViewController("HomeViewController", title: "首页", imageName: "tabbar_home")
        //        addChildViewController("MessageViewController", title: "消息", imageName: "tabbar_message_center")
        //        addChildViewController("DiscoverViewController", title: "发现", imageName: "tabbar_discover")
        //        addChildViewController("ProfileViewController", title: "我", imageName: "tabbar_profile")
    }
    //MARK - private methods
    // 添加自控制器
    private func addChildViewController(childVcName: String, title: String, imageName: String) {
        // 获取名字空间
        guard let nameSpace = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as? String else {
            return
        }
        // 根据字符串获取对应的Class
        guard let childVcClass = NSClassFromString(nameSpace + "." + childVcName ) else {
            return;
        }
        // 将对应的AnyObject转成控制器的类型
        guard let childVcType = childVcClass as? UITableViewController.Type else {
            return
        }
        // 创建对应的控制器对象
        let childVc = childVcType.init()
        childVc.title = title
        childVc.tabBarItem.image = UIImage(named: imageName)
        childVc.tabBarItem.selectedImage = UIImage(named: imageName + "_hightlighted")
        let childNav = UINavigationController(rootViewController: childVc)
        addChildViewController(childNav)
        
    }
}
// MARK:- 设置UI界面
extension MainTabBarController {
    /// 设置发布按钮
    private func setupComposeBtn() {
        tabBar.addSubview(composeBtn)
        composeBtn.center = CGPointMake(tabBar.center.x, tabBar.bounds.size.height * 0.5)
        composeBtn.addTarget(self, action: #selector(MainTabBarController.composeBtnClick), forControlEvents: .TouchUpInside)
    }
    
    /// 调整tabbar中的item
    private func setupTabbarItems() {
        // 1，遍历所有的item
        for i in 0..<tabBar.items!.count {
            // 2，获取item
            let item = tabBar.items![i]
            
            // 3，如果下标为2，则该item不可以和用户交互
            if i == 2 {
                item.enabled = false
                continue
            }
            
            // 4，设置其他item的选中时候的图片
            item.selectedImage = UIImage(named: imageNames[i] + "_highlighted")
        }
    }
}

// MARK:- 事件监听
extension MainTabBarController {
    @objc private func composeBtnClick() {
        let composeVc = ComposeViewController()
        
        let composeNav = UINavigationController(rootViewController: composeVc)
        presentViewController(composeNav, animated: true) { 
            
        }
    }
}
