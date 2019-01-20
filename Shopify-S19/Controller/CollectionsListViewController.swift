//
//  CollectionListViewController.swift
//  Shopify-S19
//
//  Created by Neelaksh Bhatia on 2019-01-17.
//  Copyright © 2019 Neelaksh Bhatia. All rights reserved.
//

import UIKit

class CollectionsListViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    struct Padding {
        static let small: CGFloat = 20
        static let medium: CGFloat = 30
        static let large: CGFloat = 50
    }

    var collectionsList: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())

    var data: [CollectionListItem] = []
    var backupData: [CollectionListItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        let sv = UIViewController.displaySpinner(onView: self.view)
        CollectionsListService.fetchCollectionList(completion: { (result) -> Void in
            UIViewController.removeSpinner(spinner: sv)
            self.data = result
            self.backupData = self.data
            self.collectionsList.reloadData()
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.searchController?.isActive = false
    }

    private func configureView() {
        self.view.backgroundColor = .white
        self.title = ShopifyStrings.collections_list_title

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
        flowLayout.estimatedItemSize = CGSize(width: self.view.frame.width, height: 200)

        collectionsList = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        collectionsList.register(UINib(nibName: "CollectionListCell", bundle: nil), forCellWithReuseIdentifier: "collectionListCell")
        collectionsList.backgroundColor = .white
        collectionsList.delegate = self
        collectionsList.dataSource = self
        self.view.addSubview(collectionsList)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let generalFont = UIFont.boldSystemFont(ofSize: 20)
        let imageViewHeight: CGFloat = 131
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]

        let expectedHeight = heightForLabel(text: [data[indexPath.row].body, data[indexPath.row].title], font: generalFont, width: CGFloat(256))
        let timeHeight = heightForLabel(text: ["\(ShopifyStrings.last_updated) \(dateFormatter.string(for: data[indexPath.row].lastUpdatedTime) ?? "unknown")"], font: generalFont, width: CGFloat(256))

        return CGSize(width: view.frame.width, height: max(expectedHeight + Padding.large, imageViewHeight + timeHeight + Padding.large))
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

extension CollectionsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            data = searchText.isEmpty ? backupData : backupData.filter({ listItem -> Bool in
                return listItem.title.contains(searchText)
            })

            collectionsList.reloadData()
        }
    }
}

extension CollectionsListViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionsList.dequeueReusableCell(withReuseIdentifier: "collectionListCell", for: indexPath) as? CollectionListCell else { fatalError("Dequeing an incompatible cell") }
        let item = self.data[indexPath.item]

        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        
        cell.titleLabel.text = item.title
        cell.titleLabel.numberOfLines = 0

        cell.bodyLabel.text = item.body
        cell.bodyLabel.numberOfLines = 0

        cell.imageView.image = item.image

        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        cell.lastUpdatedLabel.text = "\(ShopifyStrings.last_updated): \(dateFormatter.string(for: item.lastUpdatedTime) ?? "unknown")"
        cell.lastUpdatedLabel.numberOfLines = 0

        cell.backgroundColor = .white
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailsVC = CollectionsDetailViewController()
        let selectedItem = data[indexPath.item]
        detailsVC.collectionID = selectedItem.api_id
        detailsVC.selectedCollection = selectedItem
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.3) {
            cell?.backgroundColor = UIColor.lightGray
        }
        UIView.animate(withDuration: 0.2) {
            cell?.backgroundColor = UIColor.clear
        }
    }
}

