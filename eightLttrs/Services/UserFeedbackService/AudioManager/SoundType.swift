//
//  SoundManager.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 29.08.22.
//

import Foundation

enum SoundType: String {
  case success, error, buyAction

  var fileURL: URL {
    return Bundle.main.url(forResource: self.rawValue, withExtension: "wav")!
  }
}
