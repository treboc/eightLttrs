//
//  CoinShopView.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 04.11.22.
//

import SwiftUI

final class CoinShopViewModel: ObservableObject {
  enum CoinShopPageSelection {
    case shop
    case info
  }

  @Published var pageSelection: CoinShopPageSelection = .shop
}

struct CoinShopView: View {
  @StateObject private var viewModel = CoinShopViewModel()
  @ObservedObject private var shopManager = CoinShopManager.shared
  @EnvironmentObject private var mainViewModel: MainViewModel
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    ZStack {
      switch viewModel.pageSelection {
      case .shop:
        BuyPage(shopState: $viewModel.pageSelection)
          .transition(.move(edge: .leading))
      case .info:
        InfoPage(shopState: $viewModel.pageSelection)
          .transition(.move(edge: .trailing))
      }
    }
  }
}

struct CoinShopView_Previews: PreviewProvider {
  static var previews: some View {
    CoinShopView()
  }
}

