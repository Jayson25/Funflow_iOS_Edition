//
//  CategoryCollectionViewController.swift
//  Funflow
//
//  Created by Jayson Galante on 10/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit

final class MainMenuViewController: UICollectionViewController {
    
    private let reuseIdentifier = "categoryCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 10.0, bottom: 50.0, right: 10.0)

    fileprivate var availableWidth : CGFloat!
    fileprivate var widthPerItem : CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = GenericSettings.backgroundColor
        self.clearsSelectionOnViewWillAppear = true
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GenericSettings.categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! CategoryCell
        let categoryName = GenericSettings.categories[indexPath.row]!.first?.key
        
        cell.categoryIcon.image = UIImage(named: (GenericSettings.categories[indexPath.row]!.first?.value)!)?.withRenderingMode(.alwaysTemplate)
        cell.categoryIcon.tintColor = GenericSettings.themeColor
        cell.categoryTitle.text = categoryName
        cell.categoryTitle.textColor = GenericSettings.fontColor
        cell.clickable?.tag = indexPath.row
        cell.clickable?.addTarget(self, action: #selector(goToFlowsList), for: .touchUpInside)
        
        return cell
    }
    
    @objc func goToFlowsList(_ sender : UIButton){
         let listOfFlows = storyboard?.instantiateViewController(withIdentifier: "listOfFlows") as! ListOfFlowsViewControllerDecrepated
         let categoryName = GenericSettings.categories[sender.tag]!.first?.key
        
         listOfFlows.category = categoryName
         navigationController?.pushViewController(listOfFlows, animated: true)
    }
    
    func dynamicTileSize() -> CGSize{
        var itemsPerRow : CGFloat!
        
        switch UIDevice.current.orientation{
            case .portrait, .portraitUpsideDown:
                itemsPerRow = 3
            case .landscapeLeft, .landscapeRight:
                itemsPerRow = 4
            default:
                itemsPerRow = 3
        }
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
  
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let animationHandler : ((UIViewControllerTransitionCoordinatorContext) -> Void) = {[weak self] (context) in
            self?.collectionView.reloadData()
        }
        
        let completionHandler : ((UIViewControllerTransitionCoordinatorContext) -> Void) = { [weak self] (context) in
            self?.collectionView.reloadData()
        }
        
        coordinator.animateAlongsideTransition(in: self.collectionView, animation: animationHandler, completion: completionHandler)
    }
}

extension MainMenuViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView : UICollectionView, layout collectionViewLayout : UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return dynamicTileSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout : UICollectionViewLayout, insetForSectionAt section : Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout : UICollectionViewLayout, minimumLineSpacingForSectionAt section : Int) -> CGFloat{
        return sectionInsets.left
    }
}
