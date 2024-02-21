//
//  TodoOptionTableViewCell.swift
//  ReminderApp
//
//  Created by Greed on 2/21/24.
//

import UIKit
import SnapKit

class TodoOptionTableViewCell: BaseTableViewCell {
    
    let cellTitle = UILabel()
    let subTitle = UILabel()
    let buttonImage = UIImageView()
    let pickedImage = UIImageView()
    
    override func configureHierarchy() {
        contentView.addSubViews([cellTitle, subTitle, buttonImage, pickedImage])
    }
    
    override func configureLayout() {
    
        cellTitle.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(20)
            make.centerY.equalTo(contentView)
        }
        
        buttonImage.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset(-20)
            make.centerY.equalTo(contentView)
        }
        
        subTitle.snp.makeConstraints { make in
            make.trailing.equalTo(buttonImage.snp.leading).offset(-20)
            make.centerY.equalTo(contentView)
        }
        
        pickedImage.snp.makeConstraints { make in
            make.trailing.equalTo(buttonImage.snp.leading).offset(-20)
            make.centerY.equalTo(contentView)
            make.height.equalTo(contentView).inset(4)
            make.width.equalTo(80)
        }
        
    }
    
    override func configureView() {
        cellTitle.textColor = .white
        cellTitle.font = .systemFont(ofSize: 16)
        subTitle.textColor = .white
        subTitle.font = .systemFont(ofSize: 12)
        buttonImage.image = UIImage(systemName: "chevron.forward",
                                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 13, weight: .bold))
        buttonImage.tintColor = .systemGray2
        buttonImage.contentMode = .scaleAspectFit
    }
    
}
