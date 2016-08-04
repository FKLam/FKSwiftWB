//
//  NetworkingTools.swift
//  FKNetworking
//
//  Created by kun on 16/7/28.
//  Copyright © 2016年 kun. All rights reserved.
//

import AFNetworking

enum RequestType {
    case GET
    case POST
}

class NetworkingTools: AFHTTPSessionManager {
    // let是线程安全的
    static let shareInstance : NetworkingTools = {
       let networkingTools = NetworkingTools()
        networkingTools.responseSerializer.acceptableContentTypes?.insert("text/html")
        networkingTools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return networkingTools
    }()
}

// MARK:- 封装请求方法
extension NetworkingTools {
    func request(requestType: RequestType, urlString: String, parameters: [String : AnyObject], finish: (result: AnyObject?, error: NSError?) -> ()) {
        // 定义成功的回调闭包
        let successCallBack = { (task: NSURLSessionDataTask, result: AnyObject?) in
            finish(result: result, error: nil)
        }
        // 定义失败的回调闭包
        let failureCallBack = { (task: NSURLSessionDataTask?, error: NSError) in
            finish(result: nil, error: error)
        }
        // 发送网络请求
        if requestType == .GET {
            GET(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
            
        }
        else if requestType == .POST {
            POST(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
    }
}

// MARK:- 请求AccessToken
extension NetworkingTools {
    func loadAccessToken(code: String, finished: (result: [String : AnyObject]?, error: NSError?) -> () ) {
        // 获取请求的URLString
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        // 获取请求的参数
        let parameters = ["client_id" : client_id, "client_secret" : client_secret, "grant_type" : grant_type, "code" : code, "redirect_uri" : redirect_uri]
        
        // 发送网络请求
        request(.POST, urlString: urlString, parameters: parameters) { (result, error) in
            finished(result: result as? [String : AnyObject], error: error)
        }
        
    }
}

// MARK:- 请求用户的信息
extension NetworkingTools {
    func loadUserInfo(access_token: String, uid: String, finished: (result: [String : AnyObject]?, error: NSError?) -> ()) {
        // 获取请求的URLString
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        // 获取请求的参数
        let parameters = ["access_token" : access_token, "uid" : uid]
        
        // 发送网络请求
        request(.GET, urlString: urlString, parameters: parameters) { (result, error) in
            finished(result: result as? [String : AnyObject], error: error)
        }
    }
}

// MARK:- 请求首页数据
extension NetworkingTools {
    func loadStatuses(since_id: Int, max_id: Int, finished: (result: [[String : AnyObject]]?, error: NSError?) -> ()) {
        // 获取请求的URLString
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        // 获取请求的参数
        let parameters = ["access_token" : (UserAccountViewModel.shareInstance.account?.access_token)!, "since_id" : "\(since_id)", "max_id" : "\(max_id)"]
        
        // 发送网络请求
        request(.GET, urlString: urlString, parameters: parameters) { (result, error) in
            // 获取字典的数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(result: nil, error: error)
                return
            }
            
            // 将数组数据回调给外界控制器
            finished(result: resultDict["statuses"] as? [[String : AnyObject]], error: error)
        }
    }
}

// MARK:- 发送微博
extension NetworkingTools {
    func sendStatus(statusText: String, sendResult: (isSuccess: Bool) -> ()) {
        // 获取请求的URLString
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        // 获取请求的参数
        let parameters = ["access_token" : (UserAccountViewModel.shareInstance.account?.access_token)!, "status" : statusText]
        // 发送网络请求
        request(.POST, urlString: urlString, parameters: parameters) { (result, error) in
            if result != nil {
                sendResult(isSuccess: true)
            } else {
                sendResult(isSuccess: false)
            }
        }
    }
}

// MARK:- 发送微博并且携带照片
extension NetworkingTools {
    func sendStatus(statusText: String, image: UIImage, sendResult: (isSuccess: Bool) -> ()) {
        // 获取请求的URLString
        let urlString = "https://api.weibo.com/2/statuses/upload.json"
        // 获取请求的参数
        let parameters = ["access_token" : (UserAccountViewModel.shareInstance.account?.access_token)!, "status" : statusText]
        // 发送网络请求
        POST(urlString, parameters: parameters, constructingBodyWithBlock: { (formData) in
            if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                formData.appendPartWithFileData(imageData, name: "pic", fileName: "123.png", mimeType: "image/png")
            }
            }, progress: nil, success: { (_, _) in
                sendResult(isSuccess: true)
            }) { (_, _) in
                sendResult(isSuccess: false)
        }
    }
}
