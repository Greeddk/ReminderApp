//
//  RealmModel.swift
//  ReminderApp
//
//  Created by Greed on 2/15/24.
//

import Foundation
import RealmSwift

class MyList: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var regDate: Date
    @Persisted var reminderItemList: List<ReminderItem>
    
    convenience init(name: String, regDate: Date) {
        self.init()
        self.name = name
        self.regDate = regDate
    }
}

class ReminderItem: Object {
    @Persisted(primaryKey: true) var id: ObjectId //아이디
    @Persisted var title: String
    @Persisted var memo: String?
    @Persisted var dueDate: Date?
    @Persisted var tag: String?
    @Persisted var priority: String?
    @Persisted var done: Bool
    @Persisted(originProperty: "reminderItemList") var folder: LinkingObjects<MyList>
    
    convenience init(title: String, memo: String? = nil, dueDate: Date? = nil, tag: String? = nil, priority: String? = nil) {
        self.init()
        self.title = title
        self.memo = memo
        self.dueDate = dueDate
        self.tag = tag
        self.priority = priority
        self.done = false
    }

}



