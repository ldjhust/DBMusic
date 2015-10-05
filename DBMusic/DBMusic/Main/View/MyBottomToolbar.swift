//
//  MyBottomToolbar.swift
//  DBMusic
//
//  Created by ldjhust on 15/9/24.
//  Copyright © 2015年 example. All rights reserved.
//

import UIKit

class MyBottomToolbar: UIImageView {
  
  var loveBtn: UIButton!
  var playBtn: UIButton!
  var nextSongBtn: UIButton!

  init() {
    
    super.init(frame: CGRect(x: 0, y: UIScreen.mainScreen().bounds.height-44, width: UIScreen.mainScreen().bounds.width, height: 44))
    
    self.image = UIImage(named: "toolbar_bg")
    self.userInteractionEnabled = true
    
    let distance = (UIScreen.mainScreen().bounds.width-90)/4
    self.loveBtn = UIButton()
    self.loveBtn.bounds.size = CGSize(width: 30, height: 30)
    self.loveBtn.center = CGPoint(x: distance + 15, y: 22)
    self.loveBtn.setBackgroundImage(UIImage(named: "love"), forState: UIControlState.Normal)
    self.loveBtn.setBackgroundImage(UIImage(named: "loved"), forState: UIControlState.Selected)
    
    self.playBtn = UIButton()
    self.playBtn.bounds.size = CGSize(width: 30, height: 30)
    self.playBtn.center = CGPoint(x: 30 + 2 * distance + 15, y: 22)
    self.playBtn.setBackgroundImage(UIImage(named: "play"), forState: UIControlState.Normal)
    self.playBtn.setBackgroundImage(UIImage(named: "pause"), forState: UIControlState.Selected)
    
    self.nextSongBtn = UIButton()
    self.nextSongBtn.bounds.size = CGSize(width: 30, height: 30)
    self.nextSongBtn.center = CGPoint(x: 60 + 3 * distance + 15, y: 22)
    self.nextSongBtn.setBackgroundImage(UIImage(named: "next"), forState: UIControlState.Normal)
    
    self.addSubview(self.loveBtn)
    self.addSubview(self.playBtn)
    self.addSubview(self.nextSongBtn)
  }
  
  required init?(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
  }
}
