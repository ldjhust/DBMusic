//
//  HTTPTool.swift
//  DBMusic
//
//  Created by ldjhust on 15/9/26.
//  Copyright © 2015年 example. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ReachabilitySwift
import SVProgressHUD

class ReachabilityTool {
  
  static let reachability = Reachability.reachabilityForInternetConnection()
  
  private init() {
    ReachabilityTool.reachability?.startNotifier() // 开启监听
  }
}

class HTTPTool: NSObject {

  class var sharedHTTPTool: HTTPTool {
    struct Instance {
      static var onceToken: dispatch_once_t = 0
      static var instance: HTTPTool? = nil
    }
    
    dispatch_once(&Instance.onceToken) {
      Instance.instance = HTTPTool()
    }
    
    return Instance.instance!
  }
  
  // 私有化构造函数
  
  private override init() {
    
    super.init()
  }
  
  // MARK: - Private Methods
  
  private func getResource(URLString: String, parameters: [String: AnyObject]?, completeHandle: (AnyObject) -> Void) {
    
    Alamofire.request(.GET, URLString, parameters: parameters, encoding: ParameterEncoding.URL, headers: nil).responseJSON(options: NSJSONReadingOptions.AllowFragments) { (_, _, result) -> Void in
      
      switch result {
      case .Failure(_, let error):
        NSLog ("网络GET失败：\(error)")
        SVProgressHUD.showErrorWithStatus("网络获取数据失败", maskType: SVProgressHUDMaskType.Black)
      case .Success(let jsonResult):
        completeHandle(jsonResult)
      }
    }
  }
  
  // MARK: - Network API
  
  func getchannelList(completeHandle: (data: [ChannelList]) -> Void) {
    
    self.getResource("http://www.douban.com/j/app/radio/channels", parameters: nil) { (result) -> Void in
      
      let json = JSON(result)
      let channels = json["channels"].array!
      let channelLists = channels.map { (channel) -> ChannelList in
        let title = channel["name"].string!
        var id:Int?
        
        if let r = channel["channel_id"].int {
          id = r
        } else {
          id = Int(channel["channel_id"].string!)
        }
        
        return ChannelList(channelString: title, channelId: id!)
      }
      
      // 回调 返回数据
      completeHandle(data: channelLists)
    }
  }
  
  func getSongList(channelId: Int, completeHandle: (songs: [SongList]) -> Void) {
    self.getResource("http://www.douban.com/j/app/radio/people?app_name=radio_desktop_win&version=100&channel=\(channelId)&type=n", parameters: nil) { (result) -> Void in

      let json = JSON(result)
      let songs = json["song"].array!
      let songList = songs.map {
        SongList(URLString: $0["url"].string!, thumbImage: $0["picture"].string, sid: $0["sid"].string!, title: $0["title"].string, artitst: $0["artist"].string)
      }
      
      // 回调 返回数据
      completeHandle(songs: songList)
    }
  }
}
