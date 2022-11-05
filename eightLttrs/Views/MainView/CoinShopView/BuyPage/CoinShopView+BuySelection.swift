//
//  CoinShopView+BuySelection.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 04.11.22.
//

import Foundation

extension CoinShopView {
  enum BuySelection: Int {
    case one, three, five

    var buttonTitle: String {
      switch self {
      case .one:
        return "One Word"
      case .three:
        return "Three Words"
      case .five:
        return "Five Words"
      }
    }
  }
}
