//
//  ListCollectionViewCell.swift
//  ReminderApp
//
//  Created by Greed on 2/14/24.
//

import UIKit
import SnapKit

class ListCollectionViewCell: UICollectionViewCell {
    
    let backView = UIView()
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let numberLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        contentView.addSubViews([backView, imageView, titleLabel, numberLabel])
    }
    
    func configureLayout() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.top).offset(8)
            make.leading.equalTo(backView.snp.leading).offset(8)
            make.size.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalTo(imageView)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.trailing.equalTo(backView.snp.trailing).offset(-8)
            make.centerY.equalTo(imageView)
        }
    }
    
    func configureView() {
        backView.backgroundColor = .systemGray5
        backView.layer.cornerRadius = 8
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .systemBlue
        imageView.tintColor = .white
        titleLabel.textColor = .lightGray
        numberLabel.textColor = .white
        numberLabel.font = .boldSystemFont(ofSize: 24)
    }
}
