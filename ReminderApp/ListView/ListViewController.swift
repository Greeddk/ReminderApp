//
//  ListViewController.swift
//  ReminderApp
//
//  Created by Greed on 2/14/24.
//

import UIKit

class ListViewController: BaseViewController {
    
    let mainView = ListView()
    
    var newTodoButton: UIBarButtonItem!
    var addListButton: UIBarButtonItem!
    
    let titles = ["오늘", "예정", "전체", "깃발 표시", "완료됨"]
    var icons = ["13.square", "calendar", "tray.fill", "flag.fill", "checkmark"]
    let colors: [UIColor] = [.systemBlue, .systemRed, .systemGray, .systemOrange, .systemGray]
    
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
        mainView.collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "전체"
        navigationController?.navigationBar.prefersLargeTitles = true
        let moreButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .done, target: self, action: #selector(moreButtonClicked))
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

}

extension ListViewController {
    
    @objc
    private func newTodoButtonClicked() {
        let vc = UINavigationController(rootViewController: AddTodoViewController())
        present(vc, animated: true)
    }
    
    @objc
    private func addListButtonClicked() {
        
    }
    
    @objc
    private func moreButtonClicked() {
        
    }
}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath) as! ListCollectionViewCell
        cell.imageView.image = UIImage(systemName: icons[indexPath.row])
        cell.circleView.backgroundColor = colors[indexPath.row]
        cell.titleLabel.text = titles[indexPath.row]
        cell.numberLabel.text = "1"
        return cell
    }
    
}
