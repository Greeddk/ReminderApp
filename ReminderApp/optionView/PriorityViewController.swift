//
//  PriorityViewController.swift
//  ReminderApp
//
//  Created by Greed on 2/15/24.
//

import UIKit
import SnapKit

class PriorityViewController: BaseViewController {
    
    let priorityTextField = UITextField()
    var navigationTitle: String!
    
    convenience init(title: String) {
        self.init()
        self.navigationTitle = title
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureHierarchy() {
        view.addSubview(priorityTextField)
    }
    
    override func configureLayout() {
        priorityTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .systemGray6
        navigationItem.title = navigationTitle
        let cancel = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonClicked))
        let complete = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonClicked))
        navigationItem.leftBarButtonItem = cancel
        navigationItem.rightBarButtonItem = complete
        priorityTextField.keyboardType = .numberPad
        priorityTextField.backgroundColor = .systemGray5
        priorityTextField.addLeftPadding()
        priorityTextField.layer.cornerRadius = 8
        priorityTextField.placeholder = "우선순위를 설정해주세요.."
    }
    
    @objc func completeButtonClicked() {
        NotificationCenter.default.post(name: NSNotification.Name("priority"), object: nil, userInfo: ["priority": priorityTextField.text!])
        navigationController?.popViewController(animated: true)
    }
    
}
