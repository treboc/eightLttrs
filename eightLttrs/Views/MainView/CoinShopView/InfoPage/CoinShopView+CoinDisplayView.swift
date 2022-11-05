//
//  CoinShopView+CoinDisplayView.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 05.11.22.
//

import SwiftUI

extension CoinShopView {
  struct CoinsDisplayView: View {
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
                .font(.system(.caption, design: .rounded, weight: .semibold))
                .foregroundColor(.black)
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

    let coins: Int
    var isInfo: Bool = false

    var body: some View {
      HStack {
        Coins()
        Text(isInfo ? "+\(coins)" : "\(coins)")
          .foregroundColor(isInfo ? .accent : .primary)
      }
      .padding(10)
      .background(
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
          .fill(.ultraThinMaterial)
      )
    }
  }
}
