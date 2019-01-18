//
//  CollectionListViewController.swift
//  Shopify-S19
//
//  Created by Neelaksh Bhatia on 2019-01-17.
//  Copyright © 2019 Neelaksh Bhatia. All rights reserved.
//

import UIKit

class CollectionsListViewController: UIViewController {

    var collectionsList: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }


    private func configureView() {
        self.view.backgroundColor = .white
        self.title = ShopifyStrings.collections_list_title

        // init search bar
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
        self.navigationItem.hidesSearchBarWhenScrolling = false

        // init collection view
        collectionsList = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionsList.register(CollectionListCell.self, forCellWithReuseIdentifier: <#T##String#>)
        collectionsList.backgroundColor = .white
        collectionsList.delegate = self
        collectionsList.dataSource = self
        self.view.addSubview(collectionsList)

    }


}

extension CollectionsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text)
    }
}

extension CollectionsListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionListCell(frame: CGRect(x: 0, y: 0, width: 350, height: 150))
        cell.title.text = "hello"
        return cell
    }

}

