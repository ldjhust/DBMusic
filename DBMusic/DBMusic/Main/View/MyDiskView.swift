//
//  MyDiskView.swift
//  DBMusic
//
//  Created by ldjhust on 15/9/24.
//  Copyright © 2015年 example. All rights reserved.
//

import UIKit

class MyDiskView: UIView {

  var diskImageView: UIImageView!
  var diskSingerView: UIImageView!
  
  init() {
    
    super.init(frame: CGRect(x: UIScreen.mainScreen().bounds.width/2-125, y: 135, width: 250, height: 250))
    
    self.diskImageView = UIImageView()
    self.diskImageView.bounds.size = self.bounds.size
    self.diskImageView.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
    self.diskImageView.image = UIImage(named: "disc")
    
    self.diskSingerView = UIImageView()
    self.diskSingerView.bounds.size = CGSize(width: 158, height: 158)
    self.diskSingerView.center = self.diskImageView.center
    self.diskSingerView.layer.cornerRadius = self.diskSingerView.bounds.size.width/2
    self.diskSingerView.layer.masksToBounds = true
    self.diskSingerView.image = UIImage(named: "default_singer")
    
    self.addSubview(self.diskImageView)
    self.addSubview(self.diskSingerView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
  }
}
