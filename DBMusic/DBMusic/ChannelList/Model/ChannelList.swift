//
//  File.swift
//  DBMusic
//
//  Created by ldjhust on 15/9/26.
//  Copyright © 2015年 example. All rights reserved.
//

import Foundation

class ChannelList {
  
  var channelString: String // 专辑标题
  var channelId: Int // 专辑ID
  
  init(channelString: String, channelId: Int) {
    
    self.channelString = channelString
    self.channelId = channelId
  }
}