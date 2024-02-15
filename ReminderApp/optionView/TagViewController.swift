//
//  TagViewController.swift
//  ReminderApp
//
//  Created by Greed on 2/15/24.
//

import UIKit
import SnapKit

class TagViewController: BaseViewController {
    
    let tagTextField = UITextField()
    var navigationTitle: String!
    var delegate: PassDataDelegate?
    
    convenience init(title: String) {
        self.init()
        self.navigationTitle = title
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureHierarchy() {
        view.addSubview(tagTextField)
    }
    
    override func configureLayout() {
        tagTextField.snp.makeConstraints { make in
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
        
        tagTextField.backgroundColor = .systemGray5
        tagTextField.placeholder = "새로운 태그 추가.."
        tagTextField.addLeftPadding()
        tagTextField.layer.cornerRadius = 8
    }
    
    @objc func completeButtonClicked() {
        delegate?.tagReciever(text: tagTextField.text!)
        navigationController?.popViewController(animated: true)
    }
    
}
