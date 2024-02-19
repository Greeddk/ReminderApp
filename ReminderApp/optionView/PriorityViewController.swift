//
//  PriorityViewController.swift
//  ReminderApp
//
//  Created by Greed on 2/15/24.
//

import UIKit
import SnapKit

class PriorityViewController: BaseViewController {
    
    let prioritySegmentControl = UISegmentedControl()
    var navigationTitle: String!
    
    convenience init(title: String) {
        self.init()
        self.navigationTitle = title
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureHierarchy() {
        view.addSubview(prioritySegmentControl)
    }
    
    override func configureLayout() {
        prioritySegmentControl.snp.makeConstraints { make in
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
        prioritySegmentControl.insertSegment(withTitle: "상", at: 0, animated: true)
        prioritySegmentControl.insertSegment(withTitle: "중", at: 1, animated: true)
        prioritySegmentControl.insertSegment(withTitle: "하", at: 2, animated: true)
        prioritySegmentControl.selectedSegmentIndex = 0
    }
    
    @objc func completeButtonClicked() {
        let priority = prioritySegmentControl.titleForSegment(at: prioritySegmentControl.selectedSegmentIndex) ?? ""
        NotificationCenter.default.post(name: NSNotification.Name("priority"), object: nil, userInfo: ["priority": "\(priority)"])
        navigationController?.popViewController(animated: true)
    }
    
}
