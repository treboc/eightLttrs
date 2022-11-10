//
//  CoinDisplayView.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 04.11.22.
//

import SwiftUI

struct CoinsDisplayView: View {
  @ObservedObject var coinShopManager: CoinShopManager
  @State private var size: CGSize = .zero
  @State private var width: CGFloat = 0

  var body: some View {
    HStack {
      Coins()
      Spacer()
      Text("\(coinShopManager.availableCoins.formatAsShortNumber())")
        .monospacedDigit()
    }
    .padding(10)
    .background(
      RoundedRectangle(cornerRadius: Constants.cornerRadius)
        .fill(.ultraThinMaterial)
    )
    .frame(maxWidth: .infinity)
    .readSize { size in
      self.size = size
      setWidth(coinShopManager.correctWordsEntered)
    }
    .onChange(of: coinShopManager.correctWordsEntered, perform: setWidth)
    .onAppear()
    .overlay(alignment: .bottomLeading) {
      Rectangle()
        .fill(Color.accent)
        .frame(width: width, height: 2)
    }
    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
  }

  private func setWidth(_ enteredWords: Int) {
    withAnimation(.spring()) {
      width = size.width * (CGFloat(enteredWords) / 20)
    }
  }
}

extension CoinsDisplayView {
  struct Coin: View {
    var isLastCoin: Bool = false

    var body: some View {
      Circle()
        .strokeBorder(.black, lineWidth: 1, antialiased: true)
        .background(
          Circle()
            .fill(.yellow)
        )
        .overlay {
          if isLastCoin {
            Text("P")
              .font(.system(.caption2, design: .rounded, weight: .semibold))
              .foregroundColor(.black)
              .dynamicTypeSize(.medium)
          }
        }
        .frame(width: 18, height: 18)
    }
  }

  struct Coins: View {
    var body: some View {
      ZStack {
        ForEach(0..<3, id: \.self) { index in
          let xOffset: CGFloat = CGFloat(index * 6)
          Coin(isLastCoin: index == 2)
            .offset(x: xOffset)
        }
      }
      .frame(width: 30, alignment: .leading)
    }
  }
}
