//
//  HomeViewController.swift
//  FKSwiftWB
//
//  Created by kun on 16/7/24.
//  Copyright © 2016年 kun. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HomeViewController: BaseViewController {
    
    // MARK:- 懒加载属性
    private lazy var titleBtn : UIButton = TitleButton()
    // 注意，在闭包中如果使用当前对象的属性或者调用方法，也需要加self
    private lazy var popverAnimator : PopoverAnimator = PopoverAnimator {[weak self] (presented) in
        self?.titleBtn.selected = presented
    }
    private lazy var viewModels: [StatusViewModel] = [StatusViewModel]()
    private lazy var tipLabel: UILabel = UILabel()
    private lazy var photoBrowserAnimator: PhotoBrowserAnimator = PhotoBrowserAnimator()
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView.addRotationAnim()
        
        // 没有登录时设置的内容
        if !isLogin {
            return
        }
        
        // 设置导航栏的内容
        setupNavigationBar()
        
        // 根据约束来估计高度需要设置的属性
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        // 设置headerView
        setupHeaderView()
        
        // 设置footerView
        setupFooterView()
        
        setupTipLabel()
        
        setupNotifications()
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

// MARK:- 设置UI界面
extension HomeViewController {
    private func setupNavigationBar() {
        // 设置左侧的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        
        // 设置右侧的Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        // 设置titleView
        titleBtn.setTitle("FK", forState: .Normal)
        titleBtn.addTarget(self, action: #selector(HomeViewController.titelBtnClick(_:)), forControlEvents: .TouchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    private func setupHeaderView() {
        // 创建headerView
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewStatuses))
        
        // 设置header的属性
        header.setTitle("下拉刷新", forState: .Idle)
        header.setTitle("释放更新", forState: .Pulling)
        header.setTitle("加载中...", forState: .Refreshing)
        
        // 设置tableView的header
        tableView.mj_header = header
        
        // 进入刷新状态
        tableView.mj_header.beginRefreshing()
    }
    
    private func setupFooterView() {
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadMoreStatuses))
    }
    
    private func setupTipLabel() {
        navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
        
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.mainScreen().bounds.width, height: 32)
        
        tipLabel.backgroundColor = UIColor.orangeColor()
        tipLabel.textColor = UIColor.whiteColor()
        tipLabel.font = UIFont.systemFontOfSize(14)
        tipLabel.textAlignment = .Center
        tipLabel.hidden = true
    }
    
    private func setupNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.photoItemClick(_:)), name: ShowPhotoBrowserNot, object: nil)
    }
}

// MARK:- 事件监听的函数
extension HomeViewController {
    @objc private func titelBtnClick(titelBtn : TitleButton) {
        // 改变按钮的状态
        titleBtn.selected = !titleBtn.selected
        
        // 创建弹出的控制器
        let popoverVc = PopoverViewController()
        
        // 设置控制器的modal样式
        popoverVc.modalPresentationStyle = .Custom
        
        // 设置转场的代理
        popoverVc.transitioningDelegate = popverAnimator
        popverAnimator.presentFrame = CGRect(x: 100, y: 100, width: 180, height: 250)
        
        // 弹出控制器
        presentViewController(popoverVc, animated: true, completion: nil)
        
    }
    @objc private func photoItemClick(not: NSNotification) {
        // 取出数据
        let indexPath = not.userInfo![ShowPhotoBrowserIndexKey] as! NSIndexPath
        let picURLs = not.userInfo![ShowPhotoBrowserUrlKey] as! [NSURL]
        // 创建控制器
        let photoBrowserVc = PhotoBrowserController(indexPath: indexPath, picURLs: picURLs)
        let object = not.object as! PicCollectionView
        // 设置modal样式
        photoBrowserVc.modalPresentationStyle = .Custom
        // 设置转场动画代理
        photoBrowserVc.transitioningDelegate = photoBrowserAnimator
        // 设置动画的代理
        photoBrowserAnimator.presentedDelegate = object
        photoBrowserAnimator.indexPath = indexPath
        photoBrowserAnimator.dismissDelegate = photoBrowserVc
        
        // 以modal的形式弹出控制器
        presentViewController(photoBrowserVc, animated: true) { 
            
        }
    }
    
}

// MARK:- 请求数据
extension HomeViewController {
    // 加载最新的数据
    @objc private func loadNewStatuses() {
        loadStatuses(true)
    }
    // 加载更多的数据
    @objc private func loadMoreStatuses() {
        loadStatuses(false)
    }

    private func loadStatuses(isNewData: Bool) {
        // 获取since_id
        var since_id = 0
        var max_id = 0
        if isNewData {
            since_id = viewModels.first?.status?.mid ?? 0
        } else {
            max_id = viewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        
        NetworkingTools.shareInstance.loadStatuses(since_id, max_id: max_id) { (result, error) in
            // 错误校验
            if error != nil {
                print(error)
                return
            }
            
            // 获取可选类型中的数据
            guard let resultArray = result else {
                return
            }
            
            // 遍历微博对应的字典
            var tempViewModel = [StatusViewModel]()
            for statusDict in resultArray {
                let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                tempViewModel.append(viewModel)
            }
            
            if isNewData {
                // 将数据放入到成员变量的数组中
                self.viewModels = tempViewModel + self.viewModels
            } else {
                self.viewModels = self.viewModels + tempViewModel
            }
            
            // 缓存图片
            self.cacheImages(self.viewModels, tempViewModel: tempViewModel, isNewStatus: isNewData)
        }
    }
    
    private func cacheImages(viewModels: [StatusViewModel], tempViewModel: [StatusViewModel], isNewStatus: Bool) {
        // 创建group
        let group = dispatch_group_create()
        
        // 缓存图片
        for viewModel in viewModels {
            for picURL in viewModel.picURLs {
                dispatch_group_enter(group)
                SDWebImageManager.sharedManager().downloadImageWithURL(picURL, options: [], progress: nil, completed: { (_, _, _, _, _) in
                    dispatch_group_leave(group)
                })
            }
        }
        
        // 刷新表格
        dispatch_group_notify(group, dispatch_get_main_queue()) { 
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            if isNewStatus {
                self.showTipLabel(tempViewModel.count)
            }
        }
    }
    
    // 显示提示的label
    private func showTipLabel(count: Int) {
        tipLabel.hidden = false
        tipLabel.text = count == 0 ? "没有新微博" : "\(count) 条微博"
        
        UIView.animateWithDuration(1.0, animations: { 
            self.tipLabel.frame.origin.y = 44
            }) { (_) in
                UIView.animateWithDuration(1.0, animations: { 
                    self.tipLabel.frame.origin.y = 10
                    }, completion: { (_) in
                        self.tipLabel.hidden = true
                })
        }
    }
}

// MARK:- tableView的数据源方法
extension HomeViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 创建cell
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCellID") as! HomeViewCell
        
        // 给cell设置数据
        cell.viewModel = viewModels[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let viewModel = viewModels[indexPath.row]
        return viewModel.cellHeight
    }
}
