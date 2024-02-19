//
//  TodoListTableViewCell.swift
//  ReminderApp
//
//  Created by Greed on 2/18/24.
//

import UIKit
import SnapKit

class TodoListTableViewCell: UITableViewCell {
    
    var checkButton = UIButton()
    var titleLabel = UILabel()
    var memoLabel = UILabel()
    var dueDate = UILabel()
    var tagLabel = UILabel()
    var priority = UILabel()

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
        contentView.addSubViews([checkButton, titleLabel, memoLabel, dueDate, tagLabel, priority])
    }
    
    func configureLayout() {
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(4)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(checkButton)
            make.leading.equalTo(checkButton.snp.trailing).offset(10)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
        }
    }
    
    func configureView() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .light)
        let image = UIImage(systemName: "circle", withConfiguration: imageConfig)
        checkButton.setImage(image, for: .normal)
        checkButton.tintColor = .systemGray2
        checkButton.scalesLargeContentImage = true
        titleLabel.textColor = .white
        memoLabel.textColor = .systemGray2
    }
}
