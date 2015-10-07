//
//  ViewController.swift
//  DBMusic
//
//  Created by ldjhust on 15/9/24.
//  Copyright © 2015年 example. All rights reserved.
//

import UIKit
import JVFloatingDrawer
import AFSoundManager
import SDWebImage
import SVProgressHUD
import ReachabilitySwift
import CoreData

protocol LoveSongDelegate {
  
  func addLoveSong(song: SongList)
  func removeLoveSong(song: SongList)
  func isAlreadyLoved(song: SongList) -> Bool
}

class ViewController: UIViewController, ChannelListDelegate, LovedSongListDelegate, AFSoundManagerDelegate {
  
  var pcseq: PCSEQVisualizer!
  var delegateLoveSong: LoveSongDelegate?
  var titleView: MyTitleView!
  var bottomView: MyBottomToolbar!
  var backgroundView: BackgroundView!
  var resetCurrentSongIndex: Bool = true
  var isFetchSongs: Bool = true
  var currentSongIndex: Int = 0
  var songTimePlayed: Int = 0
  var songStep: CGFloat = 0.0
  var songList: [SongList]? {  //歌曲列表
    didSet {
      
      if songList!.count > 0 {
        
        if self.resetCurrentSongIndex {
          self.currentSongIndex = 0 // 初始化当前歌曲的索引
        } else {
          self.resetCurrentSongIndex = true
        }
        self.playSong() // 初始化歌曲队列
      } else {
        SVProgressHUD.showErrorWithStatus("Failed", maskType: SVProgressHUDMaskType.Black)
      }
    }
  }
  var currentChannelId: Int = 0 { // 默认是原声
    
    didSet {
      self.getSongList() // 获取新的频道的歌曲
    }
  }
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor.blackColor()
    
    // 音乐可视化
    self.pcseq = PCSEQVisualizer(numberOfBars: 20)
    self.pcseq.center = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: 470)
    
    self.backgroundView = BackgroundView()
    
    self.titleView = MyTitleView()
    self.titleView.channelListBtn.addTarget(self, action: "openChannelList", forControlEvents: UIControlEvents.TouchUpInside)
    self.titleView.lovedSongBtn.addTarget(self, action: "openLovedList", forControlEvents: UIControlEvents.TouchUpInside)
    
    self.bottomView = MyBottomToolbar()
    self.bottomView.playBtn.addTarget(self, action: "playPauseBtn", forControlEvents: UIControlEvents.TouchUpInside)
    self.bottomView.loveBtn.addTarget(self, action: "loveOrUnloveSong:", forControlEvents: UIControlEvents.TouchUpInside)
    self.bottomView.nextSongBtn.addTarget(self, action: "playNextSong", forControlEvents: UIControlEvents.TouchUpInside)
    
    let swipe = UISwipeGestureRecognizer(target: self, action: "openChannelList")
    swipe.direction = UISwipeGestureRecognizerDirection.Left
    
    let swipeLeft = UISwipeGestureRecognizer(target: self, action: "openLovedList")
    swipeLeft.direction = UISwipeGestureRecognizerDirection.Right
    
    self.view.addGestureRecognizer(swipe)
    self.view.addGestureRecognizer(swipeLeft)
    
    self.view.addSubview(self.backgroundView)
    self.view.addSubview(self.titleView)
    self.view.addSubview(self.bottomView)
    self.view.addSubview(self.pcseq)
    
    // 指定AFSoundManager的代理
    AFSoundManager.sharedManager().delegate = self
    
    // 获取歌曲列表
    
    self.isFetchSongs = true
    self.getSongList()
  }
  
  // MARK: - Event Response
  
  func getSongList() {
    
    if !ReachabilityTool.reachability!.isReachable() {
      SVProgressHUD.showErrorWithStatus("No internet connection!", maskType: SVProgressHUDMaskType.Black) // 提示无网络
      
      return
    }
    
    SVProgressHUD.showWithStatus("Loading...", maskType: SVProgressHUDMaskType.Black) // 提示加载
    
    HTTPTool.sharedHTTPTool.getSongList(self.currentChannelId) { (songs) -> Void in
      
      self.songList = songs
      self.isFetchSongs = false
      
      SVProgressHUD.showSuccessWithStatus("Success", maskType: SVProgressHUDMaskType.Black) // 提示加载成功
    }
  }
  
  // 打开频道列表
  
  func openChannelList() {
    
    (UIApplication.sharedApplication().keyWindow?.rootViewController as! JVFloatingDrawerViewController).toggleDrawerWithSide(JVFloatingDrawerSide.Right, animated: true, completion: nil)
  }
  
  // 打开喜欢歌曲列表
  
  func openLovedList() {
    
    (UIApplication.sharedApplication().keyWindow?.rootViewController as! JVFloatingDrawerViewController).toggleDrawerWithSide(JVFloatingDrawerSide.Left, animated: true, completion: nil)
  }
  
  // 播放暂停
  
  func playPauseBtn() {
    
    if self.bottomView.playBtn.selected {
      AFSoundManager.sharedManager().pause() // 暂停
    } else {
      AFSoundManager.sharedManager().resume() // 恢复
    }
  }
  
  func play() {
    self.bottomView.playBtn.selected = true
    
    self.backgroundView.needleRotateStart()
     self.pcseq.start() // 开启音乐可视化
    
    if self.backgroundView.diskFirstRotate {
      self.backgroundView.diskFirstRotate = false
      self.backgroundView.diskRotate()
    } else {
      self.backgroundView.diskResume()
    }
  }
  
  func pause() {
    self.bottomView.playBtn.selected = false
    self.pcseq.stop() // 停止音乐可视化
    self.backgroundView.needleRotateStop()
    self.backgroundView.diskPause()
  }
  
  // 播放下一首歌
  
  func playNextSong() {
    
    if AFSoundManager.sharedManager().status == AFSoundManagerStatus.Playing.rawValue {
      AFSoundManager.sharedManager().pause() // 停止播放
    }
    
    self.currentSongIndex += 1 // 下一曲
    
    if self.currentSongIndex < self.songList!.count {
      
      // 立即切换太快，看不到唱针暂停效果，暂停
      
      NSTimer.scheduledTimerWithTimeInterval(0.3, block: { () -> Void in
        
        self.playSong() // 播放
        
        }, repeats: false)
    } else {
      
      if !self.isFetchSongs {
        self.getSongList()
      }
    }
  }
  
  // 喜欢或去喜欢一首歌
  
  func loveOrUnloveSong(sender: UIButton) {
    
    if sender.selected {
      sender.selected = false
      
      // 删除一首喜欢的歌曲
      self.delegateLoveSong?.removeLoveSong(self.songList![self.currentSongIndex])
    } else {
      sender.selected = true
      let transform = sender.transform
      UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
        sender.transform = CGAffineTransformMakeScale(1.1, 1.1)
        }) { (finished) in
          sender.transform = transform
      }
      
      // 添加一首喜欢歌曲
      
      self.delegateLoveSong?.addLoveSong(self.songList![self.currentSongIndex])
      
      SVProgressHUD.showSuccessWithStatus("收藏成功")
    }
  }
  
  // MARK: - private method
  
  // 根据秒数计算时间字符串
  
  private func timeToString(second: CGFloat) -> String {
    
    let minutes = Int(second) / 60
    let sec = Int(second) % 60
    
    return "\(minutes):" + (sec >= 10 ? "\(sec)" : "0\(sec)")
  }
  
  // 初始化这首歌相关的信息
  private func setSongInfo(song: SongList) {
    
    self.backgroundView.initBackgroundView(song)
    self.titleView.singerNameLabel.text = song.artitst
    self.titleView.songNameLabel.text = song.title
    
    if self.delegateLoveSong!.isAlreadyLoved(song) {
      song.isLoved = true
    } else {
      song.isLoved = false
    }
    
    if song.isLoved {
      self.bottomView.loveBtn.selected = true
    } else {
      self.bottomView.loveBtn.selected = false
    }
  }
  
  // 播放歌曲
  private func playSong() {
    
    // 设置歌曲的信息
    
    self.setSongInfo(self.songList![self.currentSongIndex])
    self.songTimePlayed = 0
    self.songStep = 0.0
    
    // 利用AFSoundManager播放
    
    AFSoundManager.sharedManager().startStreamingRemoteAudioFromURL(self.songList![self.currentSongIndex].songURLString) { (percentage, elapsedTime, timeRemain, error, finished) -> Void in
      
      if error == nil {
        
        if abs(timeRemain) < 1e-6 && percentage == 100 {
          // 播放完了，接着下一曲
          self.pause() // 暂停动画
          self.playNextSong()
        } else {
          
          if timeRemain > 0.0 {
            if Int(elapsedTime + 0.5) == 0 {
              // 未开始播放
              self.backgroundView.songTimeLabel.text = self.timeToString(timeRemain)
              self.songStep = (self.backgroundView.songLengthView.bounds.width - self.backgroundView.currentTimeView.bounds.width) / timeRemain
            }
            
            // 已经开始播放的时间
            self.backgroundView.currentTimeView.currentTimeLabel.text = self.timeToString(elapsedTime + 0.5)
            
            if Int(elapsedTime + 0.5) > self.songTimePlayed {
              self.songTimePlayed = Int(elapsedTime + 0.5)
              self.backgroundView.progress(self.songStep) // 有时间流失才调用，因为这个回调不是刚好按照1s回调一次
            }
          }
        }
      } else {
        print (error)
      }
    }
  }
  
  // MARK: ChannelListDelegate
  
  func changeChannelId(id: Int) {
    
    if AFSoundManager.sharedManager().status == AFSoundManagerStatus.Playing.rawValue {
      AFSoundManager.sharedManager().pause() // 暂停
    }
    
    self.resetCurrentSongIndex = true
    
    self.currentChannelId = id
  }
  
  // MARK: - LoveSong Delegate
  
  func setLovedSongList(loveSongList: [SongList], index: Int) {
    
    if AFSoundManager.sharedManager().status == AFSoundManagerStatus.Playing.rawValue {
      AFSoundManager.sharedManager().pause() // 暂停
    }
    
    self.resetCurrentSongIndex = false
    self.currentSongIndex = index
    self.songList = loveSongList
  }
  
  // MARK: - AFSoundManagerDelegate
  
  func currentPlayingStatusChanged(status: AFSoundManagerStatus) {
    
    switch status {
    case .Finished, .Paused, .Stopped:
      self.pause()
    case .Playing, .Restarted:
      self.play()
    }
  }
  
  // MARK: - Override Super
  
  override func didReceiveMemoryWarning() {
    
    super.didReceiveMemoryWarning()
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    
    return UIStatusBarStyle.LightContent
  }
}