//
//  UIFont+Extension.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 03.11.22.
//

import UIKit

extension UIFont {
  static func baseword() -> UIFont {
    var titleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
    titleFont = UIFont(descriptor: titleFont
      .fontDescriptor
      .withDesign(.rounded)?
      .withSymbolicTraits(.traitBold)
                       ?? titleFont.fontDescriptor, size: titleFont.pointSize
    )
    return titleFont
  }
}
