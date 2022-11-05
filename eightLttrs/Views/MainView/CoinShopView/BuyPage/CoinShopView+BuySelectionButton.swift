//
//  CoinShopView+BuySelectionButton.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 04.11.22.
//

import SwiftUI

extension CoinShopView {
  struct BuySelectionButton: View {
    let buttonSelection: CoinShopManager.BuyWords
    @Binding var selection: CoinShopManager.BuyWords
    let namespace: Namespace.ID
    @State private var buttonSize: CGSize = .zero

    private var price: Text {
      switch buttonSelection {
      case .one:
        return Text(.init("\(L10n.CoinShopView.BuyPage.price(15))"))
      case .three:
        return Text(.init("\(L10n.CoinShopView.BuyPage.strikethroughPrice(30, 25))"))
      case .five:
        return Text(.init("\(L10n.CoinShopView.BuyPage.strikethroughPrice(45, 37))"))
      }
    }

    private var buttonTitle: String {
      switch buttonSelection {
      case .one:
        return L10n.CoinShopView.BuyPage.oneWord
      case .three:
        return L10n.CoinShopView.BuyPage.threeWords
      case .five:
        return L10n.CoinShopView.BuyPage.fiveWords
      }
    }

    var body: some View {
      VStack {
        Text(buttonTitle)
          .font(.system(.headline, design: .rounded, weight: .semibold))
          .foregroundColor(Color(uiColor: .systemBackground))

        price
          .font(.system(.caption, design: .rounded, weight: .light))
          .foregroundColor(Color(uiColor: .secondarySystemBackground))
      }
      .padding()
      .frame(maxWidth: .infinity)
      .background(
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
          .fill(Color.accent.gradient)
          .overlay {
            if selection == buttonSelection {
              RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(Color(uiColor: .tertiarySystemBackground).gradient, lineWidth: 3)
            }
          }
          .readSize(onChange: { buttonSize in
            self.buttonSize = buttonSize
          })
          .overlay { selection == buttonSelection ? checkmarkOverlay : nil }
      )
      .onTapGesture { selection = buttonSelection }
      .padding(.horizontal, 50)
    }

    private var checkmarkOverlay: some View {
      Image(systemName: "checkmark.seal.fill")
        .font(.title2)
        .symbolRenderingMode(.palette)
        .foregroundStyle(.black, .white)
        .offset(x: buttonSize.width / 2, y: -(buttonSize.height / 2))
        .matchedGeometryEffect(id: "checkmark", in: namespace)
        .shadow(radius: 3)
    }
  }
}
