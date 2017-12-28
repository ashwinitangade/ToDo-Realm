//
//  Item.swift
//  ToDo Realm
//
//  Created by Ashwini Tangade on 12/28/17.
//  Copyright © 2017 Ashwini Tangade. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date = Date()
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
