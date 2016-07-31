//
//  Extensions.swift
//  Nox
//
//  Created by Chase McCoy on 7/31/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit

extension UIView {
  func roundCorners(corners:UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.CGPath
    self.layer.mask = mask
  }
}
