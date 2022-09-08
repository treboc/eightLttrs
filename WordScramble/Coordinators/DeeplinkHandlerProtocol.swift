//
//  DeeplinkHandlerProtocol.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 08.09.22.
//

import Foundation

protocol DeeplinkHandlerProtocol {
  func canOpenURL(_ url: URL) -> Bool
  func openURL(_ url: URL)
}
