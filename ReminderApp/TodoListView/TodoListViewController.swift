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
        mainView.tableView.rowHeight = UITableView.automaticDimension
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
        mainView.tableView.reloadData()
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
        
        var fullText = ""
        if text == "" {
            fullText = title
        } else {
            fullText = text + " " + title
        }
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
        if row.done {
            cell.checkButton.setImage(UIImage(systemName: "circle.inset.filled", withConfiguration: imageConfig), for: .normal)
            cell.checkButton.tintColor = .systemBlue
        } else {
            cell.checkButton.setImage(UIImage(systemName: "circle", withConfiguration: imageConfig), for: .normal)
            cell.checkButton.tintColor = .systemGray2
        }
        let priority = row.priority
        let title = changePriorityString(priority: priority ?? "", title: row.title)
        cell.titleLabel.attributedText = title
        cell.memoLabel.text = row.memo
        if let date = row.dueDate {
            cell.dueDate.text = changeDateFormat(data: date)
        } else {
            cell.dueDate.isHidden = true
        }
        if let tag = row.tag {
            cell.tagLabel.text = cell.dueDate.isHidden ? "#\(tag)" : "  #\(tag)"
        } else {
            cell.tagLabel.text = ""
        }
        if let image = loadImageFromDocument(filename: "\(row.id)") {
            cell.userImage.image = image
        } else {
            cell.userImage.image = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "삭제") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.repository.deleteItem(item: self.list[indexPath.row])
            self.mainView.tableView.reloadData()
        }
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}
