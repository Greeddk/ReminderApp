//
//  SelectListViewController.swift
//  ReminderApp
//
//  Created by Greed on 2/21/24.
//

import UIKit
import SnapKit
import RealmSwift

class SelectListViewController: BaseViewController {
    
    var list: Results<MyList>!
    var selectedListName: String!
    let tableView = UITableView()
    var pickedIndex: ((Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }

    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    override func configureView() {
        navigationItem.title = "목록"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
    }
    
}

extension SelectListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier)!
        let row = list[indexPath.row]
        cell.textLabel?.text = row.name
        if selectedListName == list[indexPath.row].name {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pickedIndex?(indexPath.row)
        navigationController?.popViewController(animated: true)
    }
    
}
