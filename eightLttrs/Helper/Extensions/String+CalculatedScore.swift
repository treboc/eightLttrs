//
//  String+CalculatedScore.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 23.08.22.
//

import Foundation

extension String {
  func calculatedScore() -> Int {
    switch self.count {
    case 3: return 3
    case 4: return 5
    case 5: return 9
    case 6: return 15
    case 7: return 23
    case 8: return 33
    default: return 0
    }
  }
}
