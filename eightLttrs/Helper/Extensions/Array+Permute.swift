//
//  Array+Extensions.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 28.08.22.
//

import Foundation

extension Array where Element == String {
  func permute(minStringLen: Int = 2) -> Set<String> {
    func permute(fromList: [String], toList: [String], minStringLen: Int, set: inout Set<String>) {
      if toList.count >= minStringLen {
        set.insert(toList.joined(separator: ""))
      }
      if !fromList.isEmpty {
        for (index, item) in fromList.enumerated() {
          var newFrom = fromList
          newFrom.remove(at: index)
          permute(fromList: newFrom, toList: toList + [item], minStringLen: minStringLen, set: &set)
        }
      }
    }

    var set = Set<String>()
    permute(fromList: self, toList:[], minStringLen: minStringLen, set: &set)
    return set
  }
}

