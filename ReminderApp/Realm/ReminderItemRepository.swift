//
//  ReminderItemRepository.swift
//  ReminderApp
//
//  Created by Greed on 2/18/24.
//

import Foundation
import RealmSwift

protocol DBProtocol {
    func createItem(_ item: ReminderItem)
    func updateItem(id: ObjectId, title: String, memo: String, dueDate: String, tag: String, priority: String)
    func updateDoneValue(item: ReminderItem)
    func readDB() -> Results<ReminderItem>
    func fetchDoneList() -> Results<ReminderItem>
    func sortItem(_ sortKey: String) -> Results<ReminderItem>
    func deleteItem(item: ReminderItem)
    func deleteAllDB()
}

class ReminderItemRepository: DBProtocol {
    
    let realm = try! Realm()
    
    func createItem(_ item: ReminderItem) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("create Error", error)
        }
    }
    
    func updateItem(id: ObjectId, title: String, memo: String, dueDate: String, tag: String, priority: String) {
        do {
            try realm.write {
                realm.create(ReminderItem.self, value: ["id": id, "title": title, "dueDate": dueDate, "tag": tag, "priority": priority])
            }
        } catch {
            print(error)
        }
    }
    
    func updateDoneValue(item: ReminderItem) {
        do {
            try realm.write {
                item.done.toggle()
            }
        } catch {
            print(error)
        }
    }
    
    func readDB() -> Results<ReminderItem> {
        return realm.objects(ReminderItem.self)
    }
    
    func fetchDoneList() -> Results<ReminderItem> {
        let result = realm.objects(ReminderItem.self).where {
            $0.done == true
        }
        return result
    }
    
    func sortItem(_ sortKey: String) -> Results<ReminderItem> {
        return realm.objects(ReminderItem.self).sorted(byKeyPath: sortKey, ascending: true)
    }
    
    func deleteItem(item: ReminderItem) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
    func deleteAllDB() {
        realm.deleteAll()
    }
    
}
