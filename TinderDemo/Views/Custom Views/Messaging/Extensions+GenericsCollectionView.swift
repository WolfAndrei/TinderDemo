//
//  Extensions+GenericsCollectionView.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 31.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class GenericHeaderFooterViewController<T: GenericCell<U>, U, H: UICollectionReusableView, F: UICollectionReusableView>: UICollectionViewController {

    public init(layout: UICollectionViewLayout = UICollectionViewFlowLayout(), scrollDirection: UICollectionView.ScrollDirection = .vertical) {
        if let layout = layout as? UICollectionViewFlowLayout {
            layout.scrollDirection = scrollDirection
        }
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate let cellId = "CellID"
    fileprivate let supplementaryId = "supplementaryId"
    var items = [U]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func setupHeader(_ header: H) {}
    func setupFooter(_ header: F) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(T.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(H.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: supplementaryId)
        collectionView.register(F.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: supplementaryId)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: supplementaryId, for: indexPath)
        if let header = supplementaryView as? H {
            setupHeader(header)
        }
        if let footer = supplementaryView as? F {
            setupFooter(footer)
        }
        return supplementaryView
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! T
        cell.item = items[indexPath.item]
        return cell
    }

}


class GenericHeaderViewController<T: GenericCell<U>, U, H: UICollectionReusableView>: GenericHeaderFooterViewController<T, U, H, UICollectionReusableView> {}
class GenericViewController<T: GenericCell<U>, U>: GenericHeaderViewController<T, U, UICollectionReusableView> {}




class GenericCell<U>: UICollectionViewCell {
    
    var item: U!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {}
}
















//MARK: - TABLE

class GenericTableViewController<T: GenericTableCell<U>, U>: UITableViewController {

    override init(style: UITableView.Style) {
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate let cellId = "CellID"
    var items = [U]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(T.self, forCellReuseIdentifier: cellId)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! T
        cell.item = items[indexPath.item]
        return cell
    }
}

class GenericTableCell<U>: UITableViewCell {
    
    var item: U!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {}
}
