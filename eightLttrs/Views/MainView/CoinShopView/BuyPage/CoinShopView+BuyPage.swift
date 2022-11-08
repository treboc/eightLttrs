//
//  CoinShopView+BuyPage.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 04.11.22.
//

import SwiftUI

extension CoinShopView {
  struct BuyPage: View {
    @EnvironmentObject private var viewModel: CoinShopViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var buttonSize: CGSize = .zero
    @Namespace private var buyButton

    var body: some View {
      ZStack {
        Rectangle()
          .fill(.black.opacity(0.5))
          .ignoresSafeArea()
          .onTapGesture {
            viewModel.onDismiss()
            dismiss.callAsFunction()
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
              BuySelectionButton(buttonSelection: .one, selection: $viewModel.buyOptionSelection, namespace: buyButton)
              BuySelectionButton(buttonSelection: .three, selection: $viewModel.buyOptionSelection, namespace: buyButton)
              BuySelectionButton(buttonSelection: .five, selection: $viewModel.buyOptionSelection, namespace: buyButton)
            }

            Spacer()

            HStack {
              Button(action: dismissShop) {
                Text(L10n.ButtonTitle.close)
                  .frame(maxWidth: .infinity)
              }
              .buttonStyle(.bordered)

              Button {
                viewModel.buyWordButtonTapped {
                  dismissShop()
                }
              } label: {
                Text(L10n.CoinShopView.BuyPage.buyButtonTitle)
                  .frame(maxWidth: .infinity)
              }
              .buttonStyle(.borderedProminent)
              .foregroundColor(Color(uiColor: .systemBackground))
              .disabled(viewModel.buyButtonDisabled)
            }
            .controlSize(.large)
            .padding([.horizontal, .bottom])
          }
        }
        .padding()
        .padding(.vertical, 50)
        .animation(.default, value: viewModel.buyOptionSelection)
      }
    }

    private func dismissShop() {
      viewModel.onDismiss()
      dismiss.callAsFunction()
    }

    private var pageSelectionButton: some View {
      HStack(alignment: .top) {
        CoinsDisplayView(coins: CoinShopManager.shared.availableCoins)
        Spacer()
        // Info Button
        Button {
          withAnimation {
            viewModel.pageSelection = .info
          }
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
