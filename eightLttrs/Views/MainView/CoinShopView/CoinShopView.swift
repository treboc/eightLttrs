//
//  CoinShopView.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 04.11.22.
//

import Combine
import SwiftUI

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
    .buyActionOverlay(isPresented: $viewModel.popoverIsPresented,
                      selection: viewModel.buyOptionSelection,
                      error: viewModel.buyingError)
    .environmentObject(viewModel)
  }

  init(session: Session, onDismiss: @escaping () -> Void) {
    let viewModel = CoinShopViewModel(session: session, onDismiss: onDismiss)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
}
