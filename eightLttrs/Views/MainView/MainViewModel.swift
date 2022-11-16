//
//  MainViewModel.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 06.09.22.
//

import Combine
import UIKit

final class MainViewModel: ObservableObject {
  let userFeedbackManager: UserFeedbackManager
  let gameAPI: GameService
  var session: Session

  var input = CurrentValueSubject<String, Never>("")
  var error = PassthroughSubject<WordError?, Never>()
  var resetUICallback: (() -> Void)? = nil

  @Published var coinShopManager = CoinShopManager.shared
  @Published var shopIsShown: Bool = false

  init(gameType: GameType = .continueLastSession,
       userFeedbackManager: UserFeedbackManager = .init()) {
    self.userFeedbackManager = userFeedbackManager
    self.gameAPI = GameService()
    self.session = gameAPI.continueLastSession()

    switch gameType {
    case .newSession:
      self.session = gameAPI.startGame(.newSession)
    case .shared(let word):
      self.session = gameAPI.startGame(.shared(word))
    case .continueLastSession:
      self.session = gameAPI.startGame(.continueLastSession)
    }
  }

  func submit(onCompletion: () -> Void) {
    do {
      try gameAPI.submit(input.value.uppercased(), session: session)
      userFeedbackManager.perform(.success)
      coinShopManager.enteredCorrectWord(on: session)
      input.value.removeAll()
      onCompletion()
    } catch let error as WordError {
      userFeedbackManager.perform(.error)
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
