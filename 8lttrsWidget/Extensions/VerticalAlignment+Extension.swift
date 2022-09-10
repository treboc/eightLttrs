//
//  VerticalAlignment+Extension.swift
//  WordScrambleWidgetExtension
//
//  Created by Marvin Lee Kobert on 02.09.22.
//

import SwiftUI

extension VerticalAlignment {
  struct FirstTitle: AlignmentID {
    static func defaultValue(in d: ViewDimensions) -> CGFloat {
      d[.top]
    }
  }

  static let firstTitle = VerticalAlignment(FirstTitle.self)
}
