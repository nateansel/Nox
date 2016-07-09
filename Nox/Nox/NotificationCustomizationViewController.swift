//
//  NotificationCustomizationViewController.swift
//  Nox
//
//  Created by Nathan Ansel on 6/30/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit

protocol NotificationCustomizationViewControllerDelegate {
  func selected(indexPath indexPath: NSIndexPath)
  func deselected(indexPath indexPath: NSIndexPath)
}

class NotificationCustomizationViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!
  var delegate: NotificationCustomizationViewControllerDelegate?
  let dataSource = NotificationCustomizationCollectionViewDataSource()
  let flowLayout = NotificationCustomizationCollectionViewDelegateFlowLayout()
  
  override func viewDidLoad() {
    let gradientView = Theme.Night.gradientView
    view.insertSubview(gradientView, belowSubview: collectionView)
    automaticallyAdjustsScrollViewInsets = false
    collectionView.contentInset = UIEdgeInsetsMake(navigationController?.navigationBar.frame.maxY ?? 0, 0, 8, 0)
    
    collectionView.registerNib(UINib(nibName: String(NotificationCustomizationCollectionViewCell), bundle: nil), forCellWithReuseIdentifier: String(NotificationCustomizationCollectionViewCell))
    collectionView.allowsMultipleSelection = true
    
    flowLayout.controller = self
    collectionView.dataSource = dataSource
    collectionView.delegate   = flowLayout
    collectionView.reloadData()
    selectSavedCells()
  }
  
  private func selectSavedCells() {
    if let array = NSUserDefaults.standardUserDefaults().arrayForKey("sunriseNotificationSettings") as? [Bool] {
      for (i, setting) in array.enumerate() {
        if setting {
          let indexPath = NSIndexPath(forItem: i, inSection: 0)
          collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        }
      }
    }
    else {
      let indexPath = NSIndexPath(forItem: 8, inSection: 0)
      collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
      let newSettings = [false, false, false, false, false, false, false, false,
                         true, false, false, false, false, false, false, false,
                         false, false, false, false, false, false, false, false, false]
      NSUserDefaults.standardUserDefaults().setObject(newSettings, forKey: "sunriseNotificationSettings")
    }
  }
}
