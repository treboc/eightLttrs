//
//  CoinShopView.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 04.11.22.
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
  @Published var buyOptionSelection: CoinShopManager.BuyWords = .one
  @Published var popoverIsPresented: Bool = false
  
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
  
  func buyWordButtonTapped() {
    shopManager.buy(words: buyOptionSelection, for: session)
  }

  private func loadBuyOptionSelection() {
    let selection = UserDefaults.standard.integer(forKey: "buySelection")
    buyOptionSelection = CoinShopManager.BuyWords(rawValue: selection) ?? .one
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

struct CoinShopView: View {
  @StateObject private var viewModel: CoinShopViewModel
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    ZStack {
      switch viewModel.pageSelection {
      case .shop:
        BuyPage()
          .transition(.move(edge: .leading))
      case .info:
        InfoPage()
          .transition(.move(edge: .trailing))
      }
    }
    .environmentObject(viewModel)
    .popover(present: $viewModel.popoverIsPresented) { popover in
      popover.onDismiss = dismiss.callAsFunction
    } view: {
      Text("Hello World!")
    }
  }

  init(session: Session, onDismiss: @escaping () -> Void) {
    let viewModel = CoinShopViewModel(session: session, onDismiss: onDismiss)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
}
