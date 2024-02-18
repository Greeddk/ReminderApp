//
//  ListViewController.swift
//  ReminderApp
//
//  Created by Greed on 2/14/24.
//

import UIKit
import RealmSwift

class MainListViewController: BaseViewController {
    
    let mainView = MainListView()
    
    var newTodoButton: UIBarButtonItem!
    var addListButton: UIBarButtonItem!
    
    let titles = ["오늘", "예정", "전체", "깃발 표시", "완료됨"]
    var icons = ["13.square", "calendar", "tray.fill", "flag.fill", "checkmark"]
    let colors: [UIColor] = [.systemBlue, .systemRed, .systemGray, .systemOrange, .systemGray]
    
    var list: Results<ReminderItem>!
    let repository = ReminderItemRepository()
    var counts: [Int] = [0,0,0,0,0]
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        icons[0] = changeDayIcon()
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
        let menu = UIMenu(children: [
            UIAction(title: "마감일 순", handler: { _ in
                self.list = self.repository.sortItem("dueDate")
            }),
            UIAction(title: "제목 순", handler: { _ in
                self.list = self.repository.sortItem("title")
            }),
            UIAction(title: "우선순위 낮은 순", handler: { _ in
                self.list = self.repository.sortItem("priority")
            })
        ])
        let moreButton =  UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: menu)
        navigationItem.rightBarButtonItem = moreButton
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
        list = repository.readDB()
        counts[0] = list.count
        counts[2] = list.count
//        mainView.collectionView.reloadData()
    }

}

extension MainListViewController {
    
    @objc
    private func newTodoButtonClicked() {
        let vc = UINavigationController(rootViewController: AddTodoViewController())
        present(vc, animated: true)
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
    
}
