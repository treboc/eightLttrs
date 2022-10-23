//
//  MainViewModel.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 06.09.22.
//

import Combine
import UIKit

final class MainViewModel: ObservableObject {
  let audioPlayer = AudioPlayer()
  let gameAPI: GameAPI
  var session: Session

  private let reviewService = ReviewRequestService()

  var input = CurrentValueSubject<String, Never>("")
  var error = CurrentValueSubject<WordError?, Never>(nil)
  var resetUICallback: (() -> Void)? = nil

  init(gameType: GameType = .continueLastSession) {
    self.gameAPI = GameAPI()
    self.session = gameAPI.continueLastSession()

    switch gameType {
    case .random:
      self.session = gameAPI.startGame(.random)
    case .shared(let word):
      self.session = gameAPI.startGame(.shared(word))
    case .continueLastSession:
      self.session = gameAPI.startGame(.continueLastSession)
    }
  }

  func submit(onCompletion: () -> Void) {
    do {
      try gameAPI.submit(input.value.uppercased(), session: session)
      input.value.removeAll()
      onCompletion()
      HapticManager.shared.success()
      audioPlayer.play(type: .success)
    } catch let error as WordError {
      HapticManager.shared.error()
      audioPlayer.play(type: .error)
      self.error.send(error)
    } catch {
      fatalError(error.localizedDescription)
    }
  }

  func startNewSession() {
    self.session = gameAPI.randomWordSession()
    resetUICallback?()
  }

  func startNewSession(with word: String) {
    self.session = gameAPI.newSession(with: word)
    resetUICallback?()
  }

  func resetSession(on viewController: UIViewController) {
    if !session.usedWords.isEmpty {
      UIAlertController.presentAlertController(on: viewController, with: .wordsInSession) { [unowned self] _ in
        self.startNewSession()
      }
    } else {
      startNewSession()
    }
  }
}
