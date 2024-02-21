//
//  MyListsTableViewCell.swift
//  ReminderApp
//
//  Created by Greed on 2/21/24.
//

import UIKit
import SnapKit

class MyListsTableViewCell: BaseTableViewCell {
    
    let backView = UIView()
    let circleView = UIView()
    let iconImage = UIImageView()
    let titleLabel = UILabel()
    let countLabel = UILabel()
    let buttonImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubViews([backView, circleView, iconImage, titleLabel, countLabel, buttonImage])
    }
    
    override func configureLayout() {
        backView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(2)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        circleView.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(backView).offset(12)
            make.size.equalTo(32)
        }
        
        iconImage.snp.makeConstraints { make in
            make.centerX.equalTo(circleView)
            make.centerY.equalTo(circleView)
            make.size.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(circleView)
            make.leading.equalTo(circleView.snp.trailing).offset(12)
        }
        
        buttonImage.snp.makeConstraints { make in
            make.trailing.equalTo(backView).offset(-20)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
        
        countLabel.snp.makeConstraints { make in
            make.trailing.equalTo(buttonImage.snp.leading).offset(-8)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        backView.backgroundColor = .systemGray6
        backView.layer.cornerRadius = 8
        circleView.layer.cornerRadius = 16
        circleView.backgroundColor = .systemBlue
        iconImage.image = UIImage(systemName: "list.bullet")
        iconImage.tintColor = .white
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .white
        countLabel.font = .systemFont(ofSize: 16)
        countLabel.textColor = .systemGray2
        buttonImage.image = UIImage(systemName: "chevron.forward",
                                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 13, weight: .bold))
        buttonImage.tintColor = .systemGray2
        buttonImage.contentMode = .scaleAspectFit
    }

}
