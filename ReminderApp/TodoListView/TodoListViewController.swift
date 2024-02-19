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
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(TodoListTableViewCell.self, forCellReuseIdentifier: TodoListTableViewCell.identifier)
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
    
    @objc
    private func checkButtonClicked(sender: UIButton) {
        repository.updateDoneValue(item: list[sender.tag])
        mainView.tableView.reloadData()
    }
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoListTableViewCell.identifier, for: indexPath) as! TodoListTableViewCell
        cell.checkButton.addTarget(self, action: #selector(checkButtonClicked(sender:)), for: .touchUpInside)
        cell.checkButton.tag = indexPath.row
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .light)
        let image = list[indexPath.row].done ? UIImage(systemName: "circle.fill", withConfiguration: imageConfig) : UIImage(systemName: "circle", withConfiguration: imageConfig)
        cell.checkButton.setImage(image, for: .normal)
        cell.titleLabel.text = list[indexPath.row].title
        cell.memoLabel.text = list[indexPath.row].memo
//        cell.titleLabel.text = "test"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
