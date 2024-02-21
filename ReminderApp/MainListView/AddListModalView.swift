//
//  AddListModalView.swift
//  ReminderApp
//
//  Created by Greed on 2/20/24.
//

import UIKit
import SnapKit

class AddListModalView: BaseView {
    
    let circleView = UIView()
    let iconView = UIImageView()
    let listNameTextField = UITextField()
    
    override func configureHierarchy() {
        addSubViews([circleView, iconView, listNameTextField])
    }
    
    override func configureLayout() {
        circleView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.size.equalTo(80)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalTo(circleView)
            make.centerY.equalTo(circleView)
            make.size.equalTo(50)
        }
        
        listNameTextField.snp.makeConstraints { make in
            make.top.equalTo(circleView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
    }
    
    override func configureView() {
        circleView.backgroundColor = .systemBlue
        circleView.layer.cornerRadius = 40
        iconView.image = UIImage(systemName: "list.bullet")
        iconView.tintColor = .white
        listNameTextField.placeholder = "목록 이름"
        listNameTextField.clearButtonMode = .whileEditing
        listNameTextField.textAlignment = .center
        listNameTextField.layer.cornerRadius = 8
        listNameTextField.backgroundColor = .systemGray4
    }
    
}
