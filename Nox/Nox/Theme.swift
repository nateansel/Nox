//
//  Theme.swift
//  Nox
//
//  Created by Chase McCoy on 5/29/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit
import GradientView

protocol Colorable {
  static var primaryColor: UIColor { get }
  static var secondaryColor: UIColor { get }
}

extension Colorable {
  static var gradientView: GradientView {
    let view = GradientView()
    view.frame = UIScreen.mainScreen().bounds
    view.colors = [primaryColor, secondaryColor]
    return view
  }
}

enum Theme {
  enum Day: Colorable {
    static let primaryColor = UIColor(red:1, green:0.819, blue:0, alpha:1)
    static let secondaryColor = UIColor(red:0.978, green:0.347, blue:0, alpha:1)
  }
  
  enum Night: Colorable {
    static let primaryColor = UIColor(red:0.38, green:0.188, blue:0.929, alpha:1)
    static let secondaryColor = UIColor(red:0.61, green:0.156, blue:0.706, alpha:1)
  }
}
