//
//  NotificationCustomizationCollectionViewDataSource.swift
//  Nox
//
//  Created by Nathan Ansel on 7/2/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit

class NotificationCustomizationCollectionViewDataSource: NSObject, UICollectionViewDataSource {
  
  let timeTexts = ["3 hours",
                   "2 hours\n30 min",
                   "2 hours\n30 min",
                   "2 hours\n15 min",
                   "2 hours",
                   "1 hour\n45 min",
                   "1 hour\n30 min",
                   "1 hour\n15 min",
                   "1 hour",
                   "45 min",
                   "30 min",
                   "15 min",
                   "On sunrise/sunset",
                   "15 min",
                   "30 min",
                   "45 min",
                   "1 hour",
                   "1 hour\n15 min",
                   "1 hour\n30 min",
                   "1 hour\n45 min",
                   "2 hours",
                   "2 hours\n15 min",
                   "2 hours\n30 min",
                   "2 hours\n45 min",
                   "3 hours"]
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 25
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(NotificationCustomizationCollectionViewCell), forIndexPath: indexPath) as? NotificationCustomizationCollectionViewCell
    cell?.timeText = timeTexts[indexPath.item]
    return cell!
  }
  
  
}

class NotificationCustomizationCollectionViewDelegateFlowLayout: NSObject, UICollectionViewDelegateFlowLayout {
  
  var controller: NotificationCustomizationViewController?
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    controller?.delegate?.selected(indexPath: indexPath)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let width = collectionView.frame.size.width / 3 - 8
    if indexPath.item == 12 {
      return CGSize(width: collectionView.frame.size.width, height: width)
    }
    return CGSize(width: width, height: width)
  }
}