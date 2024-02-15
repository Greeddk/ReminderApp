//
//  RealmModel.swift
//  ReminderApp
//
//  Created by Greed on 2/15/24.
//

import Foundation
import RealmSwift

class ReminderItem: Object {
    @Persisted(primaryKey: true) var id: ObjectId
}
