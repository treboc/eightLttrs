//
//  Double+Extension.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 09.11.22.
//

import Foundation

extension Double {
  func reduceScale(to places: Int) -> Double {
    let multiplier = pow(10, Double(places))
    let newDecimal = multiplier * self // move the decimal right
    let truncated = Double(Int(newDecimal)) // drop the fraction
    let originalDecimal = truncated / multiplier // move the decimal back
    return originalDecimal
  }
}

extension Int {
  func formatAsShortNumber() -> String {
    let n = self
    let num = abs(Double(n))
    let sign = (n < 0) ? "-" : ""

    switch num {
    case 1_000_000_000...:
      var formatted = num / 1_000_000_000
      formatted = formatted.reduceScale(to: 1)
      return "\(sign)\(formatted)b"

    case 1_000_000...:
      var formatted = num / 1_000_000
      formatted = formatted.reduceScale(to: 1)
      return "\(sign)\(formatted)m"

    case 1_000...:
      var formatted = num / 1_000
      formatted = formatted.reduceScale(to: 1)
      return "\(sign)\(formatted)k"

    case 0...:
      return "\(n)"

    default:
      return "\(sign)\(n)"
    }
  }
}
