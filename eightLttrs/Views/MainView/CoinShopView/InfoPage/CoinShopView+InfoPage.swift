//
//  CoinShopView+InfoPage.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 04.11.22.
//

import SwiftUI

extension CoinShopView {
  struct InfoPage: View {
    @Binding var shopState: CoinShopViewModel.CoinShopPageSelection
    @ObservedObject private var shopManager = CoinShopManager.shared
    @EnvironmentObject private var viewModel: MainViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
      ZStack {
        Rectangle()
          .fill(.black.opacity(0.5))
          .ignoresSafeArea()
          .onTapGesture {
            dismiss.callAsFunction()
            viewModel.shopIsShown = false
          }

        ZStack {
          RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .fill(.thinMaterial)
            .shadow(radius: 5)

          VStack {
            pageSelectionButton

            ScrollView {
              VStack {
                // 1. Bar for next word
                InfoPageGauge20Words(correctWords: shopManager.correctWordsEntered)

                // 2. Bar for 50%/Session
                InfoPageGauge50Percent(session: viewModel.session)

                // 3. Bar for 100%/Session
                InfoPageGauge100Percent(session: viewModel.session)
              }
              .padding([.horizontal, .bottom])

              Divider()

              VStack {
                Text(L10n.CoinShopView.InfoPage.heading)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .font(.system(.title3, design: .rounded, weight: .semibold))
                  .padding(.horizontal)

                HStack(spacing: 20) {
                  CoinsDisplayView(coins: 20, isInfo: true)

                  Text(L10n.CoinShopView.InfoPage._20correctWords)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .multilineTextAlignment(.trailing)
                }
                .padding()
                .background(Color.black.opacity(0.3), in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
                .padding(.horizontal)

                HStack(spacing: 20) {
                  CoinsDisplayView(coins: 40, isInfo: true)
                  Text(L10n.CoinShopView.InfoPage._50percentReached)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .multilineTextAlignment(.trailing)
                }
                .padding()
                .background(Color.black.opacity(0.3), in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
                .padding(.horizontal)

                HStack(spacing: 20) {
                  CoinsDisplayView(coins: 90, isInfo: true)
                  Text(L10n.CoinShopView.InfoPage._100percentReached)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .multilineTextAlignment(.trailing)
                }
                .padding()
                .background(Color.black.opacity(0.3), in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
                .padding(.horizontal)
              }
              .padding(.bottom)
            }
          }
        }
        .padding()
        .padding(.vertical, 50)
      }
    }

    private func setPage(_ shopState: CoinShopViewModel.CoinShopPageSelection) {
      withAnimation {
        self.shopState = shopState
      }
    }

    private var pageSelectionButton: some View {
      HStack {
        // Info Button
        Button {
          setPage(.shop)
        } label: {
          HStack {
            Image(systemName: "chevron.left")
            Text(L10n.CoinShopView.InfoPage.shopPageSelectionButtonTitle)
          }
          .font(.headline)
        }
        .padding([.leading, .top])
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

