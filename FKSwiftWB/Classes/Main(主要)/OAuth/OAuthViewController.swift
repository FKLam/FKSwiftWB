//
//  OAuthViewController.swift
//  FKSwiftWB
//
//  Created by kun on 16/7/29.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    // MARK:- 控件的属性
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置导航栏的内容
        setupNavigationBar()
        
        // 加载网页
        loadPage()
    }

}

// MARK:- 设置UI界面相关
extension OAuthViewController {
    private func setupNavigationBar() {
        // 设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(OAuthViewController.leftBarBtnClick))
        
        // 设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .Plain, target: self, action: #selector(OAuthViewController.rightBarBtnClick))
        
        // 设置标题
        title = "登录页面"
    }
    
    private func loadPage() {
        // 获取登录页面的URLString
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        
        // 创建对应的NSURL
        guard let url = NSURL(string: urlString) else {
            return
        }
        
        // 创建NSURLRequest对象
        let request = NSURLRequest(URL: url)
        
        // 加载request对象
        webView.loadRequest(request)
    }
}

// MARK:- 事件监听方法
extension OAuthViewController {
    @objc private func leftBarBtnClick() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func rightBarBtnClick() {
        // 书写js代码：javaScript
        let jsCode = "document.getElementById('userId').value = 'lfk01201002@3g.sina.cn'; document.getElementById('passwd').value = '01201002lfk';"
        
        // 执行js代码
        webView.stringByEvaluatingJavaScriptFromString(jsCode)
    }
}

// MARK:- webView的Delegate方法
extension OAuthViewController : UIWebViewDelegate {
    // webView开始加载网页
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    // webView网页加载完成
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    // webView加载网页失败
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        SVProgressHUD.dismiss()
    }
    
    // 当准备加载页面时，会执行该方法
    // 返回值：true－>继续加载该页面；false->不会加载该页面
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 获取加载网页的NSURL
        guard let url = request.URL else {
            return true
        }
        
        // 获取url中的字符串
        let urlString = url.absoluteString
        
        // 判断字符串中是否包含code
        guard urlString.containsString("code=") else {
            return true
        }
        
        // 将code截取出来
        let code = urlString.componentsSeparatedByString("code=").last!
        print(url)
        print(code)
        
        // 请求AccessToken
        loadAccessToken(code)
        
        return false
    }
}

// MARK:- 请求数据
extension OAuthViewController {
    // 请求AccessToken
    private func loadAccessToken(code: String) {
        NetworkingTools.shareInstance.loadAccessToken(code) { (result, error) in
            // 请求有错
            if error != nil {
                print(error)
                return
            }
            
            // 取到结果
            print(result)
            guard let accountDict = result else {
                print("没有获取到授权的数据")
                return
            }
            
            // 将字典转成模型对象
            let account = UserAccount(dict: accountDict)
            
            // 请求用户信息
            self.loadUserInfo(account)
        }
    }
    
    // 请求用户信息
    private func loadUserInfo(accout: UserAccount) {
        // 获取AccessToken
        guard let accessToken = accout.access_token else {
            return
        }
        
        // 获取uid
        guard let uid = accout.uid else {
            return
        }
        
        // 发送网络请求
        NetworkingTools.shareInstance.loadUserInfo(accessToken, uid: uid) { (result, error) in
            // 校验
            if error != nil {
                print(error)
                return
            }
            
            // 获取到用户信息的结果
            guard let userInfoDict = result else {
                return
            }
            // 从字典中取出昵称和用户头像地址
            accout.screen_name = userInfoDict["screen_name"] as? String
            accout.avatar_large = userInfoDict["avatar_large"] as? String
            
            // 将account对象保存
            NSKeyedArchiver.archiveRootObject(accout, toFile: UserAccountViewModel.shareInstance.accountPath)
            
            UserAccountViewModel.shareInstance.account = accout
            
            // 退出当前控制器
            self.dismissViewControllerAnimated(false, completion: {
                UIApplication.sharedApplication().keyWindow?.rootViewController = WelcomeViewController()
            })
        }
        
    }
}
