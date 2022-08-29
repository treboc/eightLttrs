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
  var possibleScorePublisher: CurrentValueSubject<(Int, Int), Never> { get set }
  var possibleWordsPublisher: CurrentValueSubject<(Int, Int), Never> { get set }

  var startWords: Set<String> { get set }
  var possibleWords: Set<String> { set get }
  var currentWord: String { get set }

  var currentSession: Session { get set }
  var usedWords: [WordCellItem] { get set }
  var possibleWordsForCurrentWord: Set<String> { get }
  var currentScore: Int { get }

  func startGame()
  func startGame(with word: String)

  func endGame(playerName: String)

  func check(_ word: String) throws
  func submitAnswerWith(_ word: String, onCompletion: () -> Void) throws
  func getWordCellItem(at indexPath: IndexPath) -> WordCellItem
}
