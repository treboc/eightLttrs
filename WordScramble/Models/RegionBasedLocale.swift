//
//  RegionBasedLocale.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 30.08.22.
//

import Foundation

enum RegionBasedLocale: String {
  case de, at, ch, en

  var fileNameSuffix: String {
    switch self {
    case .de, .at, .ch:
      return "DE"
    default:
      return "EN"
    }
  }
}
