//
//  UIFont+Extension.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 03.11.22.
//

import UIKit

extension UIFont {
  static func preferredFont(forTextStyle style: TextStyle, weight: Weight) -> UIFont {
    let metrics = UIFontMetrics(forTextStyle: style)
    let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
    let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
    return metrics.scaledFont(for: font)
  }

  static func roundedLargeTitle() -> UIFont {
    var titleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
    titleFont = UIFont(descriptor: titleFont
      .fontDescriptor
      .withDesign(.rounded)?
      .withSymbolicTraits(.traitBold)
                       ?? titleFont.fontDescriptor, size: titleFont.pointSize
    )
    return titleFont
  }

  static func roundedHeadline() -> UIFont {
    var titleFont = UIFont.preferredFont(forTextStyle: .headline)
    titleFont = UIFont(descriptor: titleFont
      .fontDescriptor
      .withDesign(.rounded)
                       ?? titleFont.fontDescriptor, size: titleFont.pointSize
    )
    return titleFont
  }
}
