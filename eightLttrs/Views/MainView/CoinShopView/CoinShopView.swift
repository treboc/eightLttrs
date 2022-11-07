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
