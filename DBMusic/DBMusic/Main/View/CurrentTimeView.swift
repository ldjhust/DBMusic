//
//  CurrentTimeView.swift
//  DBMusic
//
//  Created by ldjhust on 15/9/25.
//  Copyright © 2015年 example. All rights reserved.
//

import UIKit

class CurrentTimeView: UIImageView {

  var currentTimeLabel: UILabel!
  
  init() {
    
    super.init(frame: CGRect(x: 0, y: 400, width: 40, height: 15))
    
    self.image = UIImage(named: "songCurrentTime")
    
    self.currentTimeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 15))
    self.currentTimeLabel.font = UIFont.systemFontOfSize(11)
    self.currentTimeLabel.text = "0.00"
    self.currentTimeLabel.textAlignment = NSTextAlignment.Center
    self.currentTimeLabel.textColor = UIColor(red: 200.0/255, green: 44.0/255, blue: 57.0/255, alpha: 1.0)
    
    self.addSubview(currentTimeLabel)
  }
  
  required init?(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
  }
}
