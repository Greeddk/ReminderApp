//
//  BaseViewController.swift
//  ReminderApp
//
//  Created by Greed on 2/14/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
    }

    func configureHierarchy() {
        
    }
    
    func configureLayout() {
        
    }
    
    func configureView() {
        
    }
    
    @objc func cancelButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
}
