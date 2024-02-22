//
//  ReminderItemRepository.swift
//  ReminderApp
//
//  Created by Greed on 2/18/24.
//

import Foundation
import RealmSwift

protocol DBProtocol {
    func createList(_ list: MyList)
    func createItem(_ list: MyList, item: ReminderItem)
    func updateItem(id: ObjectId, title: String, memo: String?, dueDate: Date?, tag: String?, priority: String?, list: MyList)
    func updateDoneValue(item: ReminderItem)
    func readReminderItem() -> Results<ReminderItem>
    func readMyLists() -> Results<MyList>
    func fetchDoneList() -> Results<ReminderItem>
    func fetchTodayList() -> Results<ReminderItem>
    func fetchFutureList() -> Results<ReminderItem>
    func sortItem(_ sortKey: String) -> Results<ReminderItem>
    func deleteItem(item: ReminderItem)
    func deleteAllDB()
}

class ReminderItemRepository: DBProtocol {
    
    let realm = try! Realm()
    
    let start = Calendar.current.startOfDay(for: Date())
    lazy var end = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
    
    func createList(_ list: MyList) {
        do {
            try realm.write {
                realm.add(list)
            }
        } catch {
            print("list create error")
        }
    }
    
    func createItem(_ list: MyList, item: ReminderItem) {
        do {
            try realm.write {
                list.reminderItemList.append(item)
            }
        } catch {
            print("create Error", error)
        }
    }
    // ???: LinkingObjects는 변경이 불가능하나요?
    func updateItem(id: ObjectId, title: String, memo: String?, dueDate: Date?, tag: String?, priority: String?, list: MyList) {
        do {
            try realm.write {
                realm.create(ReminderItem.self, value: ["id": id, "title": title, "memo": memo, "dueDate": dueDate, "tag": tag, "priority": priority, "folder": list], update: .modified)
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
    
    func readReminderItem() -> Results<ReminderItem> {
        return realm.objects(ReminderItem.self)
    }
    
    func readMyLists() -> Results<MyList> {
        return realm.objects(MyList.self)
    }
    
    func fetchDoneList() -> Results<ReminderItem> {
        let result = realm.objects(ReminderItem.self).where {
            $0.done == true
        }
        return result
    }
    
    func fetchTodayList() -> Results<ReminderItem> {
        let predicate = NSPredicate(format: "dueDate >= %@ && dueDate < %@", start as NSDate, end as NSDate)
        let list = realm.objects(ReminderItem.self).filter(predicate)
        return list
    }
    
    func fetchFutureList() -> Results<ReminderItem> {
        let predicate = NSPredicate(format: "dueDate > %@", end as NSDate)
        let list = realm.objects(ReminderItem.self).filter(predicate)
        return list
    }
    
    func sortItem(_ sortKey: String) -> Results<ReminderItem> {
        return realm.objects(ReminderItem.self).sorted(byKeyPath: sortKey, ascending: true)
    }
    
//    func deleteItems(list: List<ReminderItem>) {
//        
//    }
    
    func deleteItem<T: Object>(item: T) {
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
