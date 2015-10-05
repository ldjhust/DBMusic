//
//  SongList.swift
//  DBMusic
//
//  Created by ldjhust on 15/9/26.
//  Copyright © 2015年 example. All rights reserved.
//

import UIKit

class SongList {
  
  var songURLString: String
  var isLoved: Bool
  var sid: String
  var thumbImage: String?
  var title: String = "未知"
  var artitst: String = "未知"
  
  init(URLString: String, thumbImage: String?, sid: String, title: String?, artitst: String?) {
    
    self.songURLString = URLString
    self.isLoved = false
    self.sid = sid
    self.thumbImage = thumbImage
    
    if title != nil {
      self.title = title!
    }
    
    if artitst != nil {
      self.artitst = artitst!
    }
  }
}
