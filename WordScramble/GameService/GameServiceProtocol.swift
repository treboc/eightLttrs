//
//  GameServiceProtocol.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 26.08.22.
//

import Foundation
import Combine

protocol GameServiceProtocol {
  var wordCellItemPublisher: CurrentValueSubject<[WordCellItem], Never> { get set }
  var currentWordPublisher: CurrentValueSubject<String, Never> { get set }

  var startWords: Set<String> { get set }
  var allPossibleWords: Set<String> { set get }
  var currentWord: String { get set }

  var usedWords: [WordCellItem] { get set }
  var currentScore: Int { get }

  func startGame()
  func startGame(with word: String)

  func endGame(playerName: String)

  func check(_ word: String) throws
  func submitAnswerWith(_ word: String, onCompletion: () -> Void) throws
  func populateWordWithScore(at indexPath: IndexPath) -> WordCellItem
}