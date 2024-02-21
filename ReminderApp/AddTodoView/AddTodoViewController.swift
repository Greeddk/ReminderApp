//
//  AddTodoViewController.swift
//  ReminderApp
//
//  Created by Greed on 2/14/24.
//

import UIKit
import SnapKit
import RealmSwift

protocol PassDataDelegate {
    func tagReciever(text: String)
}

class AddTodoViewController: BaseViewController {
    
    enum ViewType {
        case add
        case modify
        
        var buttonTitle: String {
            switch self {
            case .add:
                return "추가"
            case .modify:
                return "수정"
            }
        }
    }
    
    let mainView = AddTodoView()
    let pickedImageView = UIImageView()
    
    let repository = ReminderItemRepository()
    var list: Results<MyList>!
    var item: ReminderItem?
    var viewType: ViewType = .add
    
    var delegate: ModalViewDelegate?
    
    let cellText: [String] = ["", "마감일", "태그", "우선 순위", "이미지 추가", "목록"]
    var todoTitle: String = ""
    var memo: String?
    var dueDate: Date?
    var tagText: String?
    var priority: String?
    var image = UIImage()
    var selectedListIndex: Int = 0
    
    convenience init(type: ViewType) {
        self.init()
        self.viewType = type
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(passData), name: NSNotification.Name("priority"), object: nil)
        
        list = repository.readMyLists()
        
        if viewType == .modify {
            guard let item = item else { return }
            todoTitle = item.title
            memo = item.memo
            dueDate = item.dueDate
            tagText = item.tag
            priority = item.priority
            pickedImageView.image = loadImageFromDocument(filename: "\(item.id)")
            guard let index = item.folder.first else { return }
            selectedListIndex = list.firstIndex(of: index) ?? 0
        }
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
        mainView.tableView.register(TodoOptionTableViewCell.self, forCellReuseIdentifier: TodoOptionTableViewCell.identifier)
        mainView.tableView.register(MyListsTableViewCell.self, forCellReuseIdentifier: MyListsTableViewCell.identifier)
        mainView.tableView.sectionFooterHeight = 0
    }
    
    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "새로운 할 일"
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(dismissModalView))
        let addButton = UIBarButtonItem(title: viewType.buttonTitle, style: .plain, target: self, action: #selector(addButtonClicked))
        if viewType == .add {
            addButton.isEnabled = false
        } else {
            addButton.isEnabled = true
        }
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
        let selectedList = list[selectedListIndex]
        if viewType == .add {
            let item = ReminderItem(title: todoTitle, memo: memo, dueDate: dueDate, tag: tagText, priority: priority)
            repository.createItem(selectedList, item: item)
            if let image = pickedImageView.image {
                saveImageToDocument(image: image, filename: "\(item.id)")
            }
        } else {
            guard let item = item else { return }
            repository.updateItem(id: item.id, title: todoTitle, memo: memo, dueDate: dueDate, tag: tagText, priority: priority, list: selectedList)
            removeImageFromDocument(filename: "\(item.id)")
            if let image = pickedImageView.image {
                saveImageToDocument(image: image, filename: "\(item.id)")
            }
        }
        
        delegate?.fetchReminderItem()
        dismiss(animated: true)
    }
    
    @objc
    private func passData(notification: NSNotification) {
        if let value = notification.userInfo?["priority"] as? String {
            priority = value
            mainView.tableView.reloadSections([3], with: .automatic)
        }
    }
    
    private func changePriorityToString(priority: String) -> String {
        switch priority {
        case "0": return "상"
        case "1": return "중"
        case "2": return "하"
        default: return ""
        }
    }
    
}

extension AddTodoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
            
            if indexPath.row == 0 {
                let titleTextField = UITextField()
                titleTextField.placeholder = "제목"
                titleTextField.delegate = self
                cell.contentView.addSubview(titleTextField)
                titleTextField.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(12)
                    make.leading.equalToSuperview().offset(16)
                }
                if viewType == .modify {
                    titleTextField.text = todoTitle
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
                if viewType == .modify {
                    if memo != nil {
                        memoTextView.text = memo
                        memoTextView.textColor = .white
                    } else {
                        memoTextView.text = "메모"
                        memoTextView.textColor = .systemGray2
                    }
                }
                return cell
            }
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TodoOptionTableViewCell.identifier, for: indexPath) as! TodoOptionTableViewCell
            cell.cellTitle.text = cellText[indexPath.section]
            
            if indexPath.section == 1 {
                if let date = dueDate {
                    cell.subTitle.text = changeDateFormat(data: date)
                }
                return cell
            } else if indexPath.section == 2 {
                guard let tag = tagText else { return cell }
                cell.subTitle.text = tag
                return cell
            } else if indexPath.section == 3 {
                cell.subTitle.text = changePriorityToString(priority: priority ?? "")
                return cell
            } else if indexPath.section == 4 {
                cell.pickedImage.image = pickedImageView.image
                return cell
            } else {
                cell.subTitle.text = list[selectedListIndex ?? 0].name
                return cell
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        // 값전달 연습을 위해
        if indexPath.section == 1{
            let vc = DateViewController(title: cellText[indexPath.section])
            vc.dataSpace = { value in
                self.dueDate = value
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
        } else if indexPath.section == 4 {
            let vc = UIImagePickerController()
            vc.delegate = self
            present(vc, animated: true)
        } else if indexPath.section == 5 {
            let vc = SelectListViewController()
            vc.list = list
            vc.pickedIndex = { index in
                self.selectedListIndex = index
                tableView.reloadSections([indexPath.section], with: .automatic)
            }
            vc.selectedListName = list[selectedListIndex ?? 0].name
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
            
        } else {
            memo = textView.text!
        }
    }
    
}

extension AddTodoViewController: PassDataDelegate {
    func tagReciever(text: String) {
        tagText = text
        mainView.tableView.reloadSections([2], with: .automatic)
        print(#function)
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

extension AddTodoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.pickedImageView.image = pickedImage
            mainView.tableView.reloadSections([4], with: .automatic)
        }
        dismiss(animated: true)
    }
    
}
