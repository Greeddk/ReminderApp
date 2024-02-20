//
//  ListViewController.swift
//  ReminderApp
//
//  Created by Greed on 2/14/24.
//

import UIKit
import RealmSwift

protocol ModalViewDelegate {
    func modalViewDismissed()
}

class MainListViewController: BaseViewController {
    
    let mainView = MainListView()
    
    var newTodoButton: UIBarButtonItem!
    var addListButton: UIBarButtonItem!
    
    let titles = ["오늘", "예정", "전체", "깃발 표시", "완료됨"]
    var icons = ["13.square", "calendar", "tray.fill", "flag.fill", "checkmark"]
    let colors: [UIColor] = [.systemBlue, .systemRed, .systemGray, .systemOrange, .systemGray]
    
    var todayList: Results<ReminderItem>!
    var futureList: Results<ReminderItem>!
    var list: Results<ReminderItem>!
    var doneList: Results<ReminderItem>!
    let repository = ReminderItemRepository()
    var counts: [Int] = [0,0,0,0,0]
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        icons[0] = changeDayIcon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDB()
    }
    
    override func configureView() {
        configureToolbar()
        configureNavigationBar()
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(MainListCollectionViewCell.self, forCellWithReuseIdentifier: MainListCollectionViewCell.identifier)
        fetchDB()
        
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "전체"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    private func configureToolbar() {
        navigationController?.isToolbarHidden = false
        newTodoButton = UIBarButtonItem(customView: configureToDoButton())
        addListButton = UIBarButtonItem(title: "목록 추가", style: .done, target: self, action: #selector(addListButtonClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        var items = [UIBarButtonItem]()
        [newTodoButton, flexibleSpace, addListButton].forEach { items.append($0) }
        toolbarItems = items
    }
    
    private func configureToDoButton() -> UIButton {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 10
        let button = UIButton(configuration: configuration)
        button.frame = CGRect(x: 0, y: 0, width: 115, height: 30)
        button.setTitle("새로운 할 일", for: .normal)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(newTodoButtonClicked), for: .touchUpInside)
        return button
    }
    
    private func changeDayIcon() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let result = dateFormatter.string(from: Date())
        
        return result + ".square"
    }
    
    private func fetchDB() {
        todayList = repository.fetchTodayList()
        futureList = repository.fetchFutureList()
        list = repository.readDB()
        doneList = repository.fetchDoneList()
        counts[0] = todayList.count
        counts[1] = futureList.count
        counts[2] = list.count
        counts[4] = doneList.count
        mainView.collectionView.reloadData()
    }

}

extension MainListViewController {
    
    @objc
    private func newTodoButtonClicked() {
        let vc = AddTodoViewController()
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    @objc
    private func addListButtonClicked() {
        
    }
    
}

extension MainListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainListCollectionViewCell.identifier, for: indexPath) as! MainListCollectionViewCell
        cell.imageView.image = UIImage(systemName: icons[indexPath.row])
        cell.circleView.backgroundColor = colors[indexPath.row]
        cell.titleLabel.text = titles[indexPath.row] 
        cell.numberLabel.text = "\(counts[indexPath.item])"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TodoListViewController()
        if indexPath.item == 0 {
            vc.list = repository.fetchTodayList()
        } else if indexPath.item == 1 {
            vc.list = repository.fetchFutureList()
        } else if indexPath.item == 2 {
            vc.list = repository.readDB()
        } else {
            vc.list = repository.fetchDoneList()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MainListViewController: ModalViewDelegate {
    func modalViewDismissed() {
        fetchDB()
    }
}

