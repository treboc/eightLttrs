//
//  SoundManager.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 29.08.22.
//

import Foundation

enum SoundType: String {
  case success, error

  var fileURL: URL {
    return Bundle.main.url(forResource: self.rawValue, withExtension: "wav")!
  }
}
