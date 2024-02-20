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
                self.list = self.list.sorted(byKeyPath: "dueDate", ascending: true)
                self.mainView.tableView.reloadData()
            }),
            UIAction(title: "제목 순", handler: { _ in
                self.list = self.list.sorted(byKeyPath: "title", ascending: true)
                self.mainView.tableView.reloadData()
            }),
            UIAction(title: "우선순위 낮은 순", handler: { _ in
                self.list = self.list.sorted(byKeyPath: "priority", ascending: false)
                self.mainView.tableView.reloadData()
            })
        ])
        let moreButton =  UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: menu)
        navigationItem.rightBarButtonItem = moreButton
    }
    
    @objc
    private func checkButtonClicked(sender: UIButton) {
        repository.updateDoneValue(item: list[sender.tag])
        mainView.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
    }
    
    private func changePriorityString(priority: String, title: String) -> NSMutableAttributedString {
        var text = ""
        switch priority {
        case "0":
            text = "!"
        case "1":
            text = "!!"
        case "2":
            text = "!!!"
        default :
            text = ""
        }
        
        let fullText = text + " " + title
        let attribtuedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: text)
        attribtuedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range)
        return attribtuedString
    }
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoListTableViewCell.identifier, for: indexPath) as! TodoListTableViewCell
        let row = list[indexPath.row]
        cell.checkButton.addTarget(self, action: #selector(checkButtonClicked(sender:)), for: .touchUpInside)
        cell.checkButton.tag = indexPath.row
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .light)
        let image = row.done ? UIImage(systemName: "circle.fill", withConfiguration: imageConfig) : UIImage(systemName: "circle", withConfiguration: imageConfig)
        cell.checkButton.setImage(image, for: .normal)
        let priority = row.priority
        let title = changePriorityString(priority: priority ?? "", title: row.title)
        cell.titleLabel.attributedText = title
        cell.memoLabel.text = row.memo
        if let image = loadImageFromDocument(filename: "\(row.id)") {
            cell.userImage.image = image
        } else {
            cell.userImage.image = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.repository.deleteItem(item: self.list[indexPath.row])
            self.mainView.tableView.reloadData()
        }
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
