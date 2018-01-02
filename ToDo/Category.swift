//
//  Category.swift
//  ToDo Realm
//
//  Created by Ashwini Tangade on 12/28/17.
//  Copyright © 2017 Ashwini Tangade. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    @objc dynamic var name : String = ""
    @objc dynamic var bgColor : String = "ffffff"
    let items =  List<Item>()
}
