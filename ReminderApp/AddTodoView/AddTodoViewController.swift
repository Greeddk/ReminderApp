//
//  AddTodoViewController.swift
//  ReminderApp
//
//  Created by Greed on 2/14/24.
//

import UIKit
import SnapKit

class AddTodoViewController: BaseViewController {
    
    let mainView = AddTodoView()
    let cellText: [String] = ["", "마감일", "태그", "우선 순위", "이미지 추가"]
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    override func configureView() {
        configureNavigationBar()
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        mainView.tableView.sectionFooterHeight = 0
    }
    
    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "새로운 할 일"
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonClicked))
        let addButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonClicked))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = addButton
    }

}

extension AddTodoViewController {
    
    @objc
    private func cancelButtonClicked() {
        
    }
    
    @objc
    private func addButtonClicked() {
        
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
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = cellText[indexPath.section]
            cell.textLabel?.textColor = .white
            return cell
        } else {
            if indexPath.row == 0 {
                let titleTextField = UITextField()
                titleTextField.placeholder = "제목"
                titleTextField.becomeFirstResponder()
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 50
            } else {
                return 120
            }
        } else {
            return 50
        }
    }
    
}

extension AddTodoViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray3 {
            textView.text = ""
            textView.textColor = .white
        } else {
            textView.text = "메모"
            textView.textColor = .systemGray2
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "메모"
            textView.textColor = .systemGray2
        } else {
            textView.textColor = .white
            textView.text = ""
        }
    }
    
}
