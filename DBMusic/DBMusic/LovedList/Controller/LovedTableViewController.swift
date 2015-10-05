//
//  LovedTableViewController.swift
//  DBMusic
//
//  Created by ldjhust on 15/10/1.
//  Copyright © 2015年 example. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage
import JVFloatingDrawer
import AFSoundManager
import SVProgressHUD

protocol LovedSongListDelegate {
  
  func setLovedSongList(loveSongList: [SongList], index: Int)
}

let cellId = "reuse"
let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

class LovedTableViewController: UITableViewController, LoveSongDelegate {

  var lovedSongs: [SongList]?
  var delegateLoveList: LovedSongListDelegate?
  
  // MARK: View Lifecycle
  
  override func viewDidLoad() {
    
    self.tableView.registerClass(LoveTableViewCell.self, forCellReuseIdentifier: cellId)
    
    // 获取本地喜欢数据
    
    self.loadLovedSongs()
  }
  
  // MARK: Data Persistent
  
  func loadLovedSongs() {
    
    let fetchRequest = NSFetchRequest()
    
    fetchRequest.entity = NSEntityDescription.entityForName("LoveSongs", inManagedObjectContext: appDelegate.managedObjectContext)
    
    do {
      let results = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as! [LoveSongs]
      
      self.lovedSongs = results.map {
        
        let song = SongList(URLString: $0.songURLString!, thumbImage: $0.thumbImage, sid: $0.sid!, title: $0.title, artitst: $0.artitst)
        
        song.isLoved = true
        
        return song
      }
    } catch {
      NSLog ("读取本地收藏歌曲失败")
    }
  }
  
  // MARK: - TableView DataSource
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if self.lovedSongs == nil {
      return 0
    } else {
      return self.lovedSongs!.count
    }
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = self.tableView.dequeueReusableCellWithIdentifier(cellId) as! LoveTableViewCell
    
    if self.lovedSongs![indexPath.row].thumbImage == nil {
      cell.thumbImageView.image = UIImage(named: "default_singer")
    } else {
      cell.thumbImageView.sd_setImageWithURL(NSURL(string: self.lovedSongs![indexPath.row].thumbImage!))
    }
    
    cell.titleLabel.text = self.lovedSongs![indexPath.row].title
    cell.artistLabel.text = self.lovedSongs![indexPath.row].artitst
    
    return cell
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    return "喜欢的歌曲"
  }
  
  // MARK: - UITableView Delegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    // 自动关闭左侧抽屉
    
    (UIApplication.sharedApplication().keyWindow?.rootViewController as! JVFloatingDrawerViewController).toggleDrawerWithSide(JVFloatingDrawerSide.Left, animated: true) { (finish) -> Void in
      
      if self.delegateLoveList != nil {
        self.delegateLoveList!.setLovedSongList(self.lovedSongs!, index: indexPath.row)
      }
    }
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
    return 70.0
  }
  
  // MARK: - Love Song Delegate
  
  func addLoveSong(song: SongList) {
    
    let songLocal = SongList(URLString: song.songURLString, thumbImage: song.thumbImage, sid: song.sid, title: song.title, artitst: song.artitst)
    songLocal.isLoved = true
    
    if self.lovedSongs == nil {
      self.lovedSongs = [songLocal]
    } else {
      self.lovedSongs?.append(songLocal)
    }
    
    // 刷新数据
    
    self.tableView.reloadData()
    
    // 插入数据库
    
    let loveSong = NSEntityDescription.insertNewObjectForEntityForName("LoveSongs", inManagedObjectContext: appDelegate.managedObjectContext) as! LoveSongs
    
    loveSong.title = songLocal.title
    loveSong.thumbImage = songLocal.thumbImage
    loveSong.isLoved = true
    loveSong.sid = songLocal.sid
    loveSong.songURLString = songLocal.songURLString
    loveSong.artitst = songLocal.artitst
    
    // 保存数据
    appDelegate.saveContext()
  }
  
  func removeLoveSong(song: SongList) {
    
    var index: Int = 0
    for index = 0; index < self.lovedSongs!.count; index++ {
      if self.lovedSongs![index].sid == song.sid {
        break
      }
    }
    
    // 先从数组中删除
    self.lovedSongs!.removeAtIndex(index)
    
    // 从tableView中去掉这一行
    
    self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
    
    // 从数据库中删除
    
    let fetchRequest = NSFetchRequest(entityName: "LoveSongs")
    let predicate = NSPredicate(format: "sid = \(song.sid)")
    
    fetchRequest.predicate = predicate
    
    do {
      let results = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as! [LoveSongs]
      
      // 删除
      appDelegate.managedObjectContext.deleteObject(results[0])
      
      appDelegate.saveContext()
    } catch {
      SVProgressHUD.showErrorWithStatus("删除失败", maskType: SVProgressHUDMaskType.Black)
    }
  }
  
  // 检查一首歌曲是否是被喜欢的
  
  func isAlreadyLoved(song: SongList) -> Bool {
    
    if self.lovedSongs == nil {
      return false
    }
    
    for itemSong in self.lovedSongs! {
      if itemSong.sid == song.sid {
        return true
      }
    }
    
    return false
  }
}
