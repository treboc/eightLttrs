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

  var input = CurrentValueSubject<String, Never>("")
  var error = CurrentValueSubject<WordError?, Never>(nil)
  var resetUICallback: (() -> Void)? = nil

  @Published var coinShopManager = CoinShopManager.shared
  @Published var shopIsShown: Bool = false

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
      coinShopManager.enteredCorrectWord(on: session)
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

  func buyWordButtonTapped(_ selection: CoinShopManager.BuyWords) {
    coinShopManager.buy(words: selection, for: session) { [weak self] result in
      guard let self else { return }
      switch result {
      case .success(let amount):
        self.gameAPI.boughtWords(amount, session: self.session)
      case .failure(let error):
        print(error.localizedDescription)
      }
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
