//
//  LoveSongs+CoreDataProperties.swift
//  DBMusic
//
//  Created by ldjhust on 15/10/4.
//  Copyright © 2015年 example. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension LoveSongs {

    @NSManaged var artitst: String?
    @NSManaged var isLoved: NSNumber?
    @NSManaged var songURLString: String?
    @NSManaged var thumbImage: String?
    @NSManaged var title: String?
    @NSManaged var sid: String?

}
