//
//  TodoListView.swift
//  ReminderApp
//
//  Created by Greed on 2/18/24.
//

import UIKit
import SnapKit

class TodoListView: BaseView {
    
    let tableView = UITableView()
    
    override func configureHierarchy() {
        addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        
    }
}
