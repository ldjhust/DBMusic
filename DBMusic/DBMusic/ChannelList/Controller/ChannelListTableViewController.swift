//
//  ChannelListTableViewController.swift
//  DBMusic
//
//  Created by ldjhust on 15/9/24.
//  Copyright © 2015年 example. All rights reserved.
//

import UIKit
import JVFloatingDrawer
import SVProgressHUD

protocol ChannelListDelegate {
  
  func changeChannelId(id: Int)
}

let cellReuseId = "reuseCellId"

class ChannelListTableViewController: UITableViewController {
  
  var channelList: [ChannelList]!
  var selectedChannelId: Int = 0
  var channelDelegate: ChannelListDelegate?

  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
    
    if ReachabilityTool.reachability!.isReachable() {
      // 获取别到列表
      HTTPTool.sharedHTTPTool.getchannelList { (data) -> Void in
        
        self.channelList = data
        self.tableView.reloadData()
      }
    } else {
      SVProgressHUD.showErrorWithStatus("No internet connection!", maskType: SVProgressHUDMaskType.Black) // 提示无网络
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  // MARK: - Table view data source

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if self.channelList == nil {
      return 0
    } else {
      return self.channelList.count
    }
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = self.tableView.dequeueReusableCellWithIdentifier(cellReuseId)!
    
    cell.textLabel?.textColor = UIColor.blackColor()
    cell.textLabel?.text = self.channelList[indexPath.row].channelString
    
    if self.selectedChannelId == indexPath.row {
      cell.textLabel?.textColor = UIColor.blueColor()
    }
    
    return cell
  }
  
  // MARK: TableView Delegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    self.selectedChannelId = indexPath.row
    self.tableView.reloadData() // 改变了频道，刷新数据
    
    // 自动关闭右侧抽屉
    (UIApplication.sharedApplication().keyWindow?.rootViewController as! JVFloatingDrawerViewController).toggleDrawerWithSide(JVFloatingDrawerSide.Right, animated: true) { (finished) -> Void in
      
      // 改变频道列表
      if self.channelDelegate != nil {
        self.channelDelegate!.changeChannelId(self.channelList[indexPath.row].channelId)
      }
    }
  }
}
