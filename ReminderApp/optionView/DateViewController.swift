//
//  DateViewController.swift
//  ReminderApp
//
//  Created by Greed on 2/15/24.
//

import UIKit
import SnapKit

class DateViewController: BaseViewController {
    
    let datePicker = UIDatePicker()
    var navigationTitle: String!
    var dataSpace: ((Date) -> Void)?
    
    convenience init(title: String) {
        self.init()
        self.navigationTitle = title
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureHierarchy() {
        view.addSubview(datePicker)
    }
    
    override func configureLayout() {
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(80)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }

    override func configureView() {
        view.backgroundColor = .systemGray6
        datePicker.preferredDatePickerStyle = .wheels
        navigationItem.title = navigationTitle
        let cancel = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonClicked))
        let complete = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonClicked))
        navigationItem.leftBarButtonItem = cancel
        navigationItem.rightBarButtonItem = complete
    }
    
    @objc func completeButtonClicked() {
        dataSpace?(datePicker.date)
        navigationController?.popViewController(animated: true)
    }
    
}
