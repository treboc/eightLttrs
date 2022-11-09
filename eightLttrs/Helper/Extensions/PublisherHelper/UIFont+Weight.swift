//
//  UIFont+Weight.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 07.09.22.
//

import UIKit

public extension UIFont {
  static func preferredFont(forTextStyle style: TextStyle, weight: Weight) -> UIFont {
    let metrics = UIFontMetrics(forTextStyle: style)
    let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
    let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
    return metrics.scaledFont(for: font)
  }
}
