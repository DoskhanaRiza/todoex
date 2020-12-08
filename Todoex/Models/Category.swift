//
//  Category.swift
//  Todoex
//
//  Created by Admin on 10/6/20.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var date: Date?
    @objc dynamic var id: String = ""
    @objc dynamic var done: Bool = false
    
}
