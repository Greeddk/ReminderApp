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
    let circleView = UIView()
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
        contentView.addSubViews([backView, circleView, imageView, titleLabel, numberLabel])
    }
    
    func configureLayout() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        circleView.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.top).offset(12)
            make.leading.equalTo(backView.snp.leading).offset(12)
            make.size.equalTo(32)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(circleView)
            make.centerY.equalTo(circleView)
            make.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.centerX.equalTo(imageView)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.trailing.equalTo(backView.snp.trailing).offset(-12)
            make.centerY.equalTo(imageView)
        }
    }
    
    func configureView() {
        backView.backgroundColor = .systemGray5
        backView.layer.cornerRadius = 8
        circleView.layer.cornerRadius = 16
        circleView.backgroundColor = .systemBlue
        imageView.tintColor = .white
        titleLabel.textColor = .lightGray
        numberLabel.textColor = .white
        numberLabel.font = .boldSystemFont(ofSize: 24)
    }
}
