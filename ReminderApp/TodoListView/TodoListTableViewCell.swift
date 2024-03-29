//
//  TodoListTableViewCell.swift
//  ReminderApp
//
//  Created by Greed on 2/18/24.
//

import UIKit
import SnapKit

class TodoListTableViewCell: UITableViewCell {
    
    let checkButton = UIButton()
    let titleLabel = UILabel()
    let memoLabel = UILabel()
    let stackView = UIStackView()
    let dueDate = UILabel()
    let tagLabel = UILabel()
    let userImage = UIImageView()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        contentView.addSubViews([checkButton, titleLabel, memoLabel, stackView, userImage])
        stackView.addSubViews([dueDate, tagLabel])
    }
    
    func configureLayout() {
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(checkButton)
            make.leading.equalTo(checkButton.snp.trailing).offset(4)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(2)
            make.leading.equalTo(titleLabel)
        }
        
        dueDate.snp.makeConstraints { make in
            make.top.equalTo(stackView)
            make.leading.equalTo(stackView)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView)
            make.leading.equalTo(dueDate.snp.trailing)

        }
        
        userImage.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).offset(-10)
            make.centerY.equalTo(contentView)
            make.height.equalTo(contentView).inset(4)
            make.width.equalTo(80)
        }
    }
    
    func configureView() {
        titleLabel.textColor = .white
        memoLabel.textColor = .systemGray2
        memoLabel.font = .systemFont(ofSize: 14)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        dueDate.font = .systemFont(ofSize: 14)
        dueDate.textColor = .systemGray2
        tagLabel.font = .systemFont(ofSize: 14)
        tagLabel.textColor = .systemCyan
    }
    
}
