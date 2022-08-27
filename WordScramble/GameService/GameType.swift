//
//  GameType.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 26.08.22.
//

import Foundation

enum GameType: Equatable {
  case randomWord
  case sharedWord(String)
}
