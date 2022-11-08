//
//  CoinShopViewModel.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 07.11.22.
//

import Combine
import SwiftUI

final class CoinShopViewModel: ObservableObject {
  enum CoinShopPageSelection {
    case shop
    case info
  }

  @Published var shopManager = CoinShopManager.shared
  @Published var pageSelection: CoinShopPageSelection = .shop
  @Published var buyOptionSelection: CoinShopManager.BuyOption = .one
  @Published var popoverIsPresented: Bool = false
  @Published var buyingError: Error?

  let session: Session
  var onDismiss: () -> Void

  private var cancellables = Set<AnyCancellable>()

  init(session: Session, onDismiss: @escaping () -> Void) {
    self.session = session
    self.onDismiss = onDismiss

    loadBuyOptionSelection()
    setupBuyOptionSelectionPublisher()
  }

  var buyButtonDisabled: Bool {
    let wordsLeft = session.possibleWords.count - session.usedWords.count
    return !buyOptionSelection.canBuyAmount(wordsLeft: wordsLeft, availableCoins: shopManager.availableCoins)
  }

  func buyWordButtonTapped(onCompletion: @escaping () -> Void) {
    let result = shopManager.buy(option: buyOptionSelection, for: session)
    switch result {
    case .success(_):
      popoverIsPresented.toggle()
    case .failure(let failure):
      self.buyingError = failure
      popoverIsPresented.toggle()
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      onCompletion()
    }
  }

  private func loadBuyOptionSelection() {
    let selection = UserDefaults.standard.integer(forKey: "buySelection")
    buyOptionSelection = CoinShopManager.BuyOption(rawValue: selection) ?? .one
  }

  private func setupBuyOptionSelectionPublisher() {
    $buyOptionSelection
      .dropFirst()
      .sink { option in
        UserDefaults.standard.set(option.rawValue, forKey: "buySelection")
      }
      .store(in: &cancellables)
  }
}
