//
//  GameType.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 26.08.22.
//

import Foundation

enum GameType: Equatable {
  case random
  case shared(String)
  case continueLastSession
}
