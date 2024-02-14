//
//  UIView+Extension.swift
//  ReminderApp
//
//  Created by Greed on 2/14/24.
//

import UIKit

extension UIView {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func addSubViews(_ Views: [UIView]) {
        Views.forEach { addSubview($0) }
    }
}

