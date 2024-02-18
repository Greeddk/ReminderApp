//
//  AddTodoViewController.swift
//  ReminderApp
//
//  Created by Greed on 2/14/24.
//

import UIKit
import SnapKit

protocol PassDataDelegate {
    func tagReciever(text: String)
}

class AddTodoViewController: BaseViewController {
    
    let mainView = AddTodoView()
    
    let repository = ReminderItemRepository()
    
    let cellText: [String] = ["", "마감일", "태그", "우선 순위", "이미지 추가"]
    var todoTitle: String = ""
    var memo: String?
    var dueDate: String?
    var tagText: String?
    var priority: String?
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(passData), name: NSNotification.Name("priority"), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    override func configureView() {
        configureNavigationBar()
        view.backgroundColor = .systemGray6
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        mainView.tableView.sectionFooterHeight = 0
    }
    
    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "새로운 할 일"
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(dismissModalView))
        let addButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonClicked))
        addButton.isEnabled = false
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = addButton
    }

}

extension AddTodoViewController {
    
    @objc
    func dismissModalView() {
        dismiss(animated: true)
    }
    
    @objc
    private func addButtonClicked() {
        let item = ReminderItem(title: todoTitle, memo: memo, dueDate: dueDate, tag: tagText, priority: priority)
        repository.createItem(item)
        dismiss(animated: true)
    }
    
    @objc
    private func passData(notification: NSNotification) {
        if let value = notification.userInfo?["priority"] as? String {
            priority = value
            mainView.tableView.reloadSections([3], with: .automatic)
        }
    }
    
    private func changeDateFormat(data: Date) -> String{
        let targetFormat = DateFormatter()
        targetFormat.dateFormat = "yyyy.M.d. a HH:mm"
        return targetFormat.string(from: data)
    }
    
}

extension AddTodoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        
        if indexPath.section != 0 {
            var content = cell.defaultContentConfiguration()
            content.text = cellText[indexPath.section]
            content.textProperties.color = .white
            content.textProperties.font = .systemFont(ofSize: 16)
            if indexPath.section == 1 {
                content.secondaryText = dueDate
                content.secondaryTextProperties.font = .systemFont(ofSize: 10)
            } else if indexPath.section == 2 {
                content.secondaryText = tagText
                content.secondaryTextProperties.font = .systemFont(ofSize: 10)
            } else if indexPath.section == 3 {
                content.secondaryText = priority
                content.secondaryTextProperties.font = .systemFont(ofSize: 10)
            }
            cell.contentConfiguration = content
            cell.accessoryType = .disclosureIndicator
            return cell
        } else {
            if indexPath.row == 0 {
                let titleTextField = UITextField()
                titleTextField.placeholder = "제목"
                titleTextField.becomeFirstResponder()
                titleTextField.delegate = self
                cell.contentView.addSubview(titleTextField)
                titleTextField.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(12)
                    make.leading.equalToSuperview().offset(16)
                }
                return cell
            } else {
                let memoTextView = UITextView()
                memoTextView.textContainer.maximumNumberOfLines = 8
                memoTextView.backgroundColor = .clear
                memoTextView.delegate = self
                memoTextView.text = "메모"
                memoTextView.textColor = .systemGray2
                memoTextView.font = .systemFont(ofSize: 17)
                cell.contentView.addSubview(memoTextView)
                memoTextView.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(4)
                    make.leading.equalToSuperview().offset(12)
                    make.trailing.equalToSuperview().offset(8)
                    make.bottom.equalToSuperview()
                }
                return cell
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
//        if indexPath.section != 0 {
//            let vc = viewControllers[indexPath.section - 1]
//            navigationController?.pushViewController(vc, animated: true)
//        }
        // 값전달 연습을 위해
        if indexPath.section == 1{
            let vc = DateViewController(title: cellText[indexPath.section])
            vc.dataSpace = { value in
                self.dueDate = self.changeDateFormat(data: value)
                tableView.reloadSections([indexPath.section], with: .automatic)
            }
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 2 {
            let vc = TagViewController(title: cellText[indexPath.section])
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 3 {
            let vc = PriorityViewController(title: cellText[indexPath.section])
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 50
            } else {
                return 120
            }
        } else {
            return 55
        }
    }
    
}

extension AddTodoViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "메모"
            textView.textColor = .systemGray2
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .systemGray2 else { return }
        textView.text = ""
        textView.textColor = .white
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.textColor == .systemGray2 {
            memo = ""
        } else {
            memo = textView.text!
        }
    }
    
}

extension AddTodoViewController: PassDataDelegate {
    func tagReciever(text: String) {
        tagText = text
        mainView.tableView.reloadSections([2], with: .automatic)
    }
}

extension AddTodoViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        todoTitle = textField.text!
        if textField.text == "" {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
}
