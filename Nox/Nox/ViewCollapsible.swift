//
//  ViewCollapsible.swift
//  Nox
//
//  Created by Chase McCoy on 8/25/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit

protocol ViewCollapsible {
  var collapseConstraint: NSLayoutConstraint? { get set }
  func collapseView()
  func showView()
  func isCollapsed() -> Bool
}

extension ViewCollapsible where Self: UIView {
  func collapseView() {
    collapseConstraint?.constant = -(self.frame.size.width - 40)
  }
  
  func showView() {
    collapseConstraint?.constant = 0
  }
  
  func isCollapsed() -> Bool {
    return !(collapseConstraint?.constant == 0)
  }
}