//
//  TodoListViewController.swift
//  ReminderApp
//
//  Created by Greed on 2/18/24.
//

import UIKit
import RealmSwift

class TodoListViewController: BaseViewController {
    
    let mainView = TodoListView()
    
    var list: Results<ReminderItem>!
    let repository = ReminderItemRepository()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureView() {
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "전체"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        let menu = UIMenu(children: [
            UIAction(title: "마감일 순", handler: { _ in
                self.list = self.repository.sortItem("dueDate")
            }),
            UIAction(title: "제목 순", handler: { _ in
                self.list = self.repository.sortItem("title")
            }),
            UIAction(title: "우선순위 낮은 순", handler: { _ in
                self.list = self.repository.sortItem("priority")
            })
        ])
        let moreButton =  UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: menu)
        navigationItem.rightBarButtonItem = moreButton
    }
    
}
