//
//  AppDelegate.swift
//  ReminderApp
//
//  Created by Greed on 2/14/24.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let repository = ReminderItemRepository()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let numberOfList = repository.readMyLists().count
        
        if numberOfList == 0 {
            let list = MyList(name: "미리 알림", regDate: Date())
            repository.createList(list)
        }
        
        let configuration = Realm.Configuration(schemaVersion: 3) { migration,oldSchemaVersion in
            
            //1: reminderItem -> reminderItemList로 이름 변경
            if oldSchemaVersion < 1 {
                migration.renameProperty(onType: "MyList", from: "reminderItem", to: "reminderItemList")
                print("Version: 0 -> 1")
            }
            
            //2: ReminderItem에 LinkingObject 추가 // 따로 코드 작업은 필요하지 않음
            if oldSchemaVersion < 2 {
                print("Version: 1 -> 2")
            }
            
            //3: superList를 folder로 이름 변경
            if oldSchemaVersion < 3 {
                migration.renameProperty(onType: "ReminderItem", from: "superList", to: "folder")
                print("Version: 2 -> 3")
            }
            
        }
        
        Realm.Configuration.defaultConfiguration = configuration

        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

