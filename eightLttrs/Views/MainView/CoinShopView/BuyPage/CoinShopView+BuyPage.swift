//
//  CoinShopView+BuyPage.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 04.11.22.
//

import SwiftUI

extension CoinShopView {
  struct BuyPage: View {
    @Binding var shopState: CoinShopViewModel.CoinShopPageSelection
    @AppStorage("buySelection") private var selection: CoinShopManager.BuyWords = .one
    @State private var buttonSize: CGSize = .zero
    @Namespace private var buyButton
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var mainViewModel: MainViewModel
    @ObservedObject private var shopManager = CoinShopManager.shared

    var body: some View {
      ZStack {
        Rectangle()
          .fill(.black.opacity(0.5))
          .ignoresSafeArea()
          .onTapGesture {
            dismiss.callAsFunction()
            mainViewModel.shopIsShown = false
          }

        ZStack {
          RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .fill(.thinMaterial)
            .shadow(radius: 5)

          VStack {
            pageSelectionButton

            VStack(alignment: .leading) {
              Text("Shop")
                .font(.system(.title, design: .rounded, weight: .bold))
                .padding(.bottom)

              Text(L10n.CoinShopView.BuyPage.heading)
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            Spacer()

            VStack(spacing: 20) {
              BuySelectionButton(buttonSelection: .one, selection: $selection, namespace: buyButton)
              BuySelectionButton(buttonSelection: .three, selection: $selection, namespace: buyButton)
              BuySelectionButton(buttonSelection: .five, selection: $selection, namespace: buyButton)
            }

            Spacer()

            HStack {
              Button {
                dismiss.callAsFunction()
                mainViewModel.shopIsShown = false
              } label: {
                Text(L10n.ButtonTitle.close)
                  .frame(maxWidth: .infinity)
              }
              .buttonStyle(.bordered)

              Button {
                mainViewModel.buyWordButtonTapped(selection)
                dismiss.callAsFunction()
                mainViewModel.shopIsShown = false
              } label: {
                Text(L10n.CoinShopView.BuyPage.buyButtonTitle)
                  .frame(maxWidth: .infinity)
              }
              .buttonStyle(.borderedProminent)
              .foregroundColor(Color(uiColor: .systemBackground))
              .disabled(buyButtonDisabled())
            }
            .controlSize(.large)
            .padding([.horizontal, .bottom])
          }
        }
        .padding()
        .padding(.vertical, 50)
        .animation(.default, value: selection)
      }
    }

    private func buyButtonDisabled() -> Bool {
      let wordsLeft = mainViewModel.session.possibleWords.count - mainViewModel.session.usedWords.count
      return !selection.canBuyAmount(wordsLeft: wordsLeft, availableCoins: shopManager.availableCoins)
    }

    private func setPage(_ shopState: CoinShopViewModel.CoinShopPageSelection) {
      withAnimation {
        self.shopState = shopState
      }
    }

    private var pageSelectionButton: some View {
      HStack(alignment: .top) {
        CoinsDisplayView(coins: CoinShopManager.shared.availableCoins)
        Spacer()
        // Info Button
        Button {
          setPage(.info)
        } label: {
          HStack {
            Text(L10n.CoinShopView.BuyPage.infoPageSelectionButtonTitle)
            Image(systemName: "chevron.right")
          }
          .font(.headline)
        }
      }
      .padding()
      .frame(maxWidth: .infinity)
    }
  }
}
