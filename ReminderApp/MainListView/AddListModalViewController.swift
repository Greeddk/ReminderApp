//
//  AddListModalViewController.swift
//  ReminderApp
//
//  Created by Greed on 2/20/24.
//

import UIKit

class AddListModalViewController: BaseViewController {
    
    let mainView = AddListModalView()
    
    let repository = ReminderItemRepository()
    
    var delegate: ModalViewDelegate?

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
    }
    
    override func configureView() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "새로운 목록"
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(dismissModalView))
        let addButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(addButtonClicked))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = addButton
    }
    
}

extension AddListModalViewController {
    
    @objc
    private func addButtonClicked() {
        let new = MyList(name: mainView.listNameTextField.text ?? "이름 미정", regDate: Date())
        repository.createList(new)
        delegate?.fetchLists()
        dismiss(animated: true)
    }
    
    @objc
    private func dismissModalView() {
        dismiss(animated: true)
    }
}
