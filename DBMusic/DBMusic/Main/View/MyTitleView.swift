//
//  MyTitleView.swift
//  DBMusic
//
//  Created by ldjhust on 15/9/24.
//  Copyright © 2015年 example. All rights reserved.
//

import UIKit

class MyTitleView: UIView {
  
  var songNameLabel: UILabel!
  var singerNameLabel: UILabel!
  var channelListBtn: UIButton!
  var lovedSongBtn: UIButton!
  
  init() {
    
    super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 64))
    
    self.backgroundColor = UIColor(red: 200.0/255, green: 44.0/255, blue: 57.0/255, alpha: 1.0)
    
    self.songNameLabel = UILabel(frame: CGRect(x: UIScreen.mainScreen().bounds.width/2-100, y: 16, width: 200, height: 30))
    self.songNameLabel.text = ""
    self.songNameLabel.textAlignment = NSTextAlignment.Center
    self.songNameLabel.textColor = UIColor.whiteColor()
    
    self.singerNameLabel = UILabel(frame: CGRect(x: UIScreen.mainScreen().bounds.width/2-75, y: 40, width: 150, height: 20))
    self.singerNameLabel.font = UIFont.systemFontOfSize(12)
    self.singerNameLabel.text = ""
    self.singerNameLabel.textColor = UIColor.whiteColor()
    self.singerNameLabel.textAlignment = NSTextAlignment.Center
    
    self.channelListBtn = UIButton(frame: CGRect(x: UIScreen.mainScreen().bounds.width-47, y: 27, width: 30, height: 22.5))
    self.channelListBtn.setBackgroundImage(UIImage(named: "more")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), forState: UIControlState.Normal)
    
    self.lovedSongBtn = UIButton(frame: CGRect(x: 17, y: 27, width: 30, height: 22.5))
    self.lovedSongBtn.setBackgroundImage(UIImage(named: "love"), forState: UIControlState.Normal)
    
    self.addSubview(self.lovedSongBtn)
    self.addSubview(self.songNameLabel)
    self.addSubview(self.singerNameLabel)
    self.addSubview(self.channelListBtn)
  }
  
  required init?(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
  }
}
