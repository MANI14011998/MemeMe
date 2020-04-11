//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by MANINDER SINGH on 11/04/20.
//  Copyright © 2020 MANINDER SINGH. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var emptyTextView: UILabel!
    @IBOutlet weak var gridView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.delegate = self
        gridView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gridView.reloadData()
        emptyTextView.isHidden = (MemeStorage.getCount() != 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MemeStorage.getCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCellView", for: indexPath) as! MemeCollectionViewCell
        cell.imageView.image = MemeStorage.get(indexPath.item).memeImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Process selection
        let detailViewController: MemeDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailsViewController") as! MemeDetailsViewController
        detailViewController.position = indexPath.item
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout Methods
    
    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}
