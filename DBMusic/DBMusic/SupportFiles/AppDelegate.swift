//
//  AppDelegate.swift
//  DBMusic
//
//  Created by ldjhust on 15/9/24.
//  Copyright © 2015年 example. All rights reserved.
//

import UIKit
import CoreData
import JVFloatingDrawer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var channelId: Int!
  private var centerViewController: ViewController!

  // MARK: - Application Lifecycle

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    self.window?.makeKeyAndVisible()
    
    let notFirstLanuch = NSUserDefaults.standardUserDefaults().boolForKey("notFirstLanuch")
    
    if notFirstLanuch {
      self.channelId = NSUserDefaults.standardUserDefaults().integerForKey("channelId")
    } else {
      NSUserDefaults.standardUserDefaults().setBool(true, forKey: "notFirstLanuch")
      self.channelId = 0  // 默认频道Id为0
    }
    
    let drawerViewController = JVFloatingDrawerViewController()
    let centerController = ViewController()
    let leftController = LovedTableViewController()
    let rightController = ChannelListTableViewController()

    centerController.delegateLoveSong = leftController
    rightController.channelDelegate = centerController
    leftController.delegateLoveList = centerController
    
    self.centerViewController = centerController
    drawerViewController.centerViewController = centerController
    drawerViewController.leftViewController = leftController
    drawerViewController.rightViewController = rightController
    
    drawerViewController.animator = JVFloatingDrawerSpringAnimator()
    
    self.window?.rootViewController = drawerViewController
    
    return true
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // 所有动画都会在进入后台时全部瞬间完成，这里重新从头开始动画
    ((self.window?.rootViewController as! JVFloatingDrawerViewController).centerViewController as! ViewController).backgroundView.diskRotate()
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // 在这里面保存一下频道数据，纺织applicationWillTerminate没有调用
    self.channelId = self.centerViewController.currentChannelId
    NSUserDefaults.standardUserDefaults().setInteger(self.channelId, forKey: "channelId")
  }

  func applicationWillTerminate(application: UIApplication) {
    
    // 退出应用时保存一下
    self.saveContext()
    
    // 保存频道ID
    self.channelId = self.centerViewController.currentChannelId
    NSUserDefaults.standardUserDefaults().setInteger(self.channelId, forKey: "channelId")
  }
  
  // MARK: - Core Data stack
  
  lazy var applicationDocumentsDirectory: NSURL = {

    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.count-1]
    }()
  
  lazy var managedObjectModel: NSManagedObjectModel = {

    let modelURL = NSBundle.mainBundle().URLForResource("DBMusic", withExtension: "momd")!
    return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
  
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {

    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
    var failureReason = "There was an error creating or loading the application's saved data."
    do {
      try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
    } catch {
      // Report any error we got.
      var dict = [String: AnyObject]()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
      dict[NSLocalizedFailureReasonErrorKey] = failureReason
      
      dict[NSUnderlyingErrorKey] = error as NSError
      let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)

      NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
      abort()
    }
    
    return coordinator
    }()
  
  lazy var managedObjectContext: NSManagedObjectContext = {

    let coordinator = self.persistentStoreCoordinator
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
    }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    if managedObjectContext.hasChanges {
      do {
        try managedObjectContext.save()
      } catch {

        let nserror = error as NSError
        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        abort()
      }
    }
  }
}

