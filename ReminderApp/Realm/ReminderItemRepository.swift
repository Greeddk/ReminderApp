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
    func fetchTodayList() -> Results<ReminderItem>
    func fetchFutureList() -> Results<ReminderItem>
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
    
    func fetchTodayList() -> Results<ReminderItem> {
        
        let start = Calendar.current.startOfDay(for: Date())
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
        let predicate = NSPredicate(format: "dueDate >= %@ && dueDate < %@", start as NSDate, end as NSDate)
        let list = realm.objects(ReminderItem.self).filter(predicate)

        return list
    }
    
    func fetchFutureList() -> Results<ReminderItem> {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) ?? Date()
        let predicate = NSPredicate(format: "dueDate > %@", tomorrow as NSDate)
        let list = realm.objects(ReminderItem.self).filter(predicate)
        return list
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
