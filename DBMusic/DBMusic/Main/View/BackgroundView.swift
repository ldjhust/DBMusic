//
//  BackgroundView.swift
//  DBMusic
//
//  Created by ldjhust on 15/9/24.
//  Copyright © 2015年 example. All rights reserved.
//

import UIKit

class BackgroundView: UIView {
  
  var backgroundImageView: UIImageView!
  var visualEfectView: UIVisualEffectView!
  var diskBackgroundView: UIImageView!
  var diskView: MyDiskView!
  var needleView: UIImageView!
  var needleViewOldTransform: CGAffineTransform!
  var songLengthView: UIView!
  var songProgressView: UIView!
  var currentTimeView: CurrentTimeView!
  var songTimeLabel: UILabel!
  var rotateLayer: CALayer!
  var diskFirstRotate: Bool = true
  
  // MARK: - Lifecycle
  
  init() {
    
    super.init(frame: UIScreen.mainScreen().bounds)
    
    // 播放音乐界面的图片背景
    
    self.backgroundImageView = UIImageView(frame: self.bounds)
    self.backgroundImageView.image = UIImage(named: "default_singer")
    
    // 毛玻璃效果
    
    self.visualEfectView = UIVisualEffectView(frame: self.bounds)
    self.visualEfectView.effect = UIBlurEffect(style: UIBlurEffectStyle.Light)
    self.visualEfectView.alpha = 1
    
    // 唱片圆盘
    
    self.diskView = MyDiskView()
    
    // 唱片圆盘下面的光晕，没找到乳白色，用深灰色代替
    
    self.diskBackgroundView = UIImageView()
    self.diskBackgroundView.bounds.size = CGSize(width: 260, height: 260)
    self.diskBackgroundView.center = self.diskView.center
    self.diskBackgroundView.image = UIImage(named: "disc_radio")
    self.diskBackgroundView.layer.cornerRadius = 130
    self.diskBackgroundView.layer.masksToBounds = true
    
    // 唱针
    
    self.needleView = UIImageView()
    self.needleView.bounds.size = CGSize(width: 96, height: 153)
    self.needleView.layer.anchorPoint = CGPoint(x: 0.25, y: 0.19)
    self.needleViewOldTransform = self.needleView.transform
    self.needleView.transform = CGAffineTransformMakeRotation(-CGFloat(1.0 / 8 * M_PI))
    self.needleView.center = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: 66)
    self.needleView.image = UIImage(named: "needle")
    
    // 显示进度背景
    
    self.songLengthView = UIView(frame: CGRect(x: 0, y: 405, width: UIScreen.mainScreen().bounds.width, height: 5))
    self.songLengthView.backgroundColor = UIColor.whiteColor()
    
    // 显示当前歌已经过去的背景
    
    self.songProgressView = UIView(frame: CGRect(x: 0, y: 405, width: 20, height: 5))
    self.songProgressView.backgroundColor = UIColor(red: 200.0/255, green: 44.0/255, blue: 57.0/255, alpha: 1.0)
    
    // 显示当前歌已过时间的Label
    
    self.currentTimeView = CurrentTimeView()
    
    // 显示歌总时间的Label
    
    self.songTimeLabel = UILabel(frame: CGRect(x: UIScreen.mainScreen().bounds.width-32, y: 415, width: 30, height: 12))
    self.songTimeLabel.font = UIFont.systemFontOfSize(10)
    self.songTimeLabel.text = "0:00"
    self.songTimeLabel.textColor = UIColor.whiteColor()
    self.songTimeLabel.textAlignment = NSTextAlignment.Center
    
    self.addSubview(self.backgroundImageView)
    self.addSubview(self.visualEfectView)
    self.addSubview(self.diskBackgroundView)
    self.addSubview(self.diskView)
    self.addSubview(self.needleView)
    self.addSubview(self.songLengthView)
    self.addSubview(self.songProgressView)
    self.addSubview(self.currentTimeView)
    self.addSubview(self.songTimeLabel)
  }
  
  required init?(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
  }
  
  // 唱片信息
  
  func initBackgroundView(song: SongList) {
    
    if song.thumbImage != nil {
      self.backgroundImageView.sd_setImageWithURL(NSURL(string: song.thumbImage!))
      self.diskView.diskSingerView.sd_setImageWithURL(NSURL(string: song.thumbImage!))
    } else {
      self.backgroundImageView.image = UIImage(named: "default_singer")
      self.diskView.diskSingerView.image = UIImage(named: "default_singer")
    }
    
    self.songProgressView.bounds.size.width = 20 // currentTimeView宽度的一半
    self.songProgressView.frame.origin.x = 0
    self.currentTimeView.center.x = 20
    self.currentTimeView.currentTimeLabel.text = "0:00"
  }
  
  // 进度条显示
  
  func progress(step: CGFloat) {
    
    self.currentTimeView.center.x += step
    self.songProgressView.frame.size.width = self.currentTimeView.center.x
  }
  
  // MARK: - Animate Methods
  
  // 唱片首次开始旋转
  
  func diskRotate() {
    
    self.rotateLayer = self.diskView.layer
    let animate = CABasicAnimation(keyPath: "transform.rotation.z")
    
    animate.fromValue = 0
    animate.toValue = 2 * M_PI
    animate.duration = 10.0
    animate.autoreverses = false
    animate.repeatCount = MAXFLOAT
    
    self.rotateLayer.addAnimation(animate, forKey: "rotate")
  }
  
  // 唱片旋转暂停
  
  func diskPause() {
    
    let interval = self.rotateLayer.convertTime(CACurrentMediaTime(), fromLayer: nil)
    
    self.rotateLayer.timeOffset = interval
    self.rotateLayer.speed = 0
  }
  
  // 唱片旋转恢复
  
  func diskResume() {
    
    let timePaused = self.rotateLayer.timeOffset
    
    self.rotateLayer.speed = 1.0
    self.rotateLayer.timeOffset = 0
    self.rotateLayer.beginTime = 0
    
    let timeSincePaused = self.rotateLayer.convertTime(CACurrentMediaTime(), fromLayer: nil) - timePaused
    
    self.rotateLayer.beginTime = timeSincePaused
    
  }
  
  // 唱针开始
  
  func needleRotateStart() {
    
    UIView.animateWithDuration(0.3) { () -> Void in
      
      self.needleView.transform = self.needleViewOldTransform
    }
  }
  
  // 唱针停止
  
  func needleRotateStop() {
    
    UIView.animateWithDuration(0.3) { () -> Void in
      
      self.needleView.transform = CGAffineTransformMakeRotation(-CGFloat(1.0 / 8 * M_PI))
    }
  }
}
