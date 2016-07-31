//
//  NotificationCustomizationViewController.swift
//  Nox
//
//  Created by Nathan Ansel on 6/30/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit

protocol NotificationCustomizationViewControllerDelegate {
  func selected(indexPath indexPath: NSIndexPath, settingsString: String)
  func deselected(indexPath indexPath: NSIndexPath, settingsString: String)
}

class NotificationCustomizationViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
  var delegate: NotificationCustomizationViewControllerDelegate?
  let dataSource = NotificationCustomizationCollectionViewDataSource()
  let flowLayout = NotificationCustomizationCollectionViewDelegateFlowLayout()
  var settingsString: String?
  
  override func viewDidLoad() {
    let gradientView = Theme.Night.gradientView
    view.insertSubview(gradientView, belowSubview: collectionView)
    automaticallyAdjustsScrollViewInsets = false
    collectionView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0)
    
    collectionView.registerNib(UINib(nibName: String(NotificationCustomizationCollectionViewCell), bundle: nil), forCellWithReuseIdentifier: String(NotificationCustomizationCollectionViewCell))
    collectionView.allowsMultipleSelection = true
    
    flowLayout.controller = self
    collectionView.dataSource = dataSource
    collectionView.delegate   = flowLayout
    collectionView.reloadData()
    selectSavedCells()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    collectionViewTopConstraint.constant = navigationController?.navigationBar.frame.maxY ?? 0
  }
  
  private func selectSavedCells() {
    if let array = NSUserDefaults.standardUserDefaults().arrayForKey(settingsString!) as? [Bool] {
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
      NSUserDefaults.standardUserDefaults().setObject(newSettings, forKey: settingsString!)
    }
  }
}
