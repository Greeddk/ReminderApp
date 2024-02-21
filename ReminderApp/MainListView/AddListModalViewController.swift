//
//  AddListModalViewController.swift
//  ReminderApp
//
//  Created by Greed on 2/20/24.
//

import UIKit

class AddListModalViewController: BaseViewController {
    
    let mainView = AddListModalView()

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
        
    }
    
    @objc
    private func dismissModalView() {
        dismiss(animated: true)
    }
}
