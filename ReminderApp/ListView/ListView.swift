//
//  ListView.swift
//  ReminderApp
//
//  Created by Greed on 2/14/24.
//

import UIKit
import SnapKit

class ListView: BaseView {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    override func configureHierarchy() {
        addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        self.inputViewController?.navigationController?.isToolbarHidden = false
    }

}

extension ListView {
    static func configureCollectionViewLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 12
        let cellWidth = UIScreen.main.bounds.width - 3 * spacing - 4
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.itemSize = CGSize(width: cellWidth / 2, height: 80)
        layout.scrollDirection = .vertical
        return layout
    }
}
