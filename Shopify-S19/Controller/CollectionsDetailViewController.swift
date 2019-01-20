//
//  CollectionsDetailViewController.swift
//  Shopify-S19
//
//  Created by Neelaksh Bhatia on 2019-01-19.
//  Copyright © 2019 Neelaksh Bhatia. All rights reserved.
//

import UIKit

class CollectionsDetailViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    struct Padding {
        static let small: CGFloat = 20
        static let medium: CGFloat = 30
        static let large: CGFloat = 50
    }

    var collectionID: Int = 0
    var selectedCollection: CollectionListItem?
    var data: [ProductListItem] = []
    var backupData: [ProductListItem] = []
    var productList: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        let sv = UIViewController.displaySpinner(onView: self.view)
        CollectionDetailService.fetchCollects(collection_id: collectionID) { result -> Void in
            UIViewController.removeSpinner(spinner: sv)
            self.data = result
            self.backupData = self.data
            guard let selectedCollection = self.selectedCollection else {
                self.productList.reloadData()
                return
            }
            let collectionDetailCard = ProductListItem(title: selectedCollection.title, body: selectedCollection.body, image: selectedCollection.image)
            self.data.insert(collectionDetailCard, at: 0)
            self.backupData = self.data
            self.productList.reloadData()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.searchController?.isActive = false
    }

    private func configureView() {
        self.title = ShopifyStrings.collection_details
        self.view.backgroundColor = .white

        // init search bar
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.dimsBackgroundDuringPresentation = false
        self.navigationItem.searchController = search
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

        // init collection view
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 0
        flowLayout.estimatedItemSize = CGSize(width: self.view.frame.width, height: 300)

        productList = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        productList.register(UINib(nibName: "ProductListCell", bundle: nil), forCellWithReuseIdentifier: "productListCell")
        productList.backgroundColor = .white
        productList.delegate = self
        productList.dataSource = self
        self.view.addSubview(productList)
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let generalFont = UIFont.boldSystemFont(ofSize: 20)
        let imageViewHeight: CGFloat = 131
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]

        let expectedHeight = heightForLabel(text: [data[indexPath.row].body], font: generalFont, width: CGFloat(256))

        return CGSize(width: view.frame.width, height: expectedHeight + imageViewHeight + Padding.large)
    }

    private func heightForLabel(text: [String], font: UIFont, width: CGFloat) -> CGFloat {
        var result: CGFloat = 0
        text.forEach { item in
            let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.font = font
            label.text = item
            label.sizeToFit()
            result += label.frame.height
        }

        return result
    }
}

extension CollectionsDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productListCell", for: indexPath) as? ProductListCell else { fatalError("Dequeing an incompatible cell type") }
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5

        let productAtIndex = data[indexPath.item]

        cell.productNameLabel.text = productAtIndex.title
        cell.productNameLabel.numberOfLines = 0

        cell.bodyLabel.text = productAtIndex.body
        cell.bodyLabel.numberOfLines = 0

        if let inventory = productAtIndex.inventory {
            cell.inventoryLabel.text = "\(inventory) \(ShopifyStrings.inventory_units)"
        }
        else {
            cell.inventoryLabel.text = ""
        }
        cell.inventoryLabel.numberOfLines = 0

        cell.productImageView.image = productAtIndex.image

        // collection details card special stuff
        if indexPath.item == 0 && productAtIndex.collectionFlag {
            cell.backgroundColor = UIColor(red:0.00, green:0.27, blue:0.56, alpha:1.0)
            cell.bodyLabel.textAlignment = .center
            cell.bodyLabel.textColor = .white
            cell.productNameLabel.textColor = .white
        }
        else {
            cell.backgroundColor = .white
            cell.bodyLabel.textAlignment = .natural
            cell.bodyLabel.textColor = .black
            cell.productNameLabel.textColor = .black
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let oldValue = cell?.backgroundColor
        UIView.animate(withDuration: 0.3) {
            cell?.backgroundColor = UIColor.lightGray
        }
        UIView.animate(withDuration: 0.2) {
            cell?.backgroundColor = oldValue
        }
    }


}

extension CollectionsDetailViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            data = searchText.isEmpty ? backupData : backupData.filter({ listItem -> Bool in
                // title searchable, can easily make other fields searchable here
                return listItem.title.contains(searchText)
            })
            productList.reloadData()
        }
    }
}
