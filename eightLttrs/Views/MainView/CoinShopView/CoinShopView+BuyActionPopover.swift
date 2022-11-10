//
//  CoinShopView+BuyActionPopover.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 07.11.22.
//

import SwiftUI

struct CoinShopBuyActionPopover<PresetingOn>: View where PresetingOn: View {
  @Binding var isPresented: Bool
  let presentedOn: () -> PresetingOn
  let selection: CoinShopManager.BuyOption
  var error: Error? = nil

  var body: some View {
    ZStack {
      if isPresented {
        Color.black
          .ignoresSafeArea()
      }

      self.presentedOn()
        .blur(radius: isPresented ? 5 : 0)
        .allowsHitTesting(!isPresented)

      if isPresented {
        VStack {
          AnimatedCheckmark(animationDuration: 0.6)
            .padding(50)

          if let error {
            Text(L10n.CoinShopView.BuyPage.BuyAction.error(error.localizedDescription))
          } else {
            Text(L10n.CoinShopView.BuyPage.BuyAction.successful)
          }
        }
        .padding(30)
        .background(
          RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .fill(.ultraThinMaterial)
            .shadow(radius: 3)
        )
        .padding(30)
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isPresented = false
          }
        }
      }
    }
    .animation(.default, value: isPresented)
  }
}

extension View {
  func buyActionOverlay(isPresented: Binding<Bool>,
                        selection: CoinShopManager.BuyOption,
                        error: Error? = nil) -> some View {
    CoinShopBuyActionPopover(isPresented: isPresented, presentedOn: {
      self
    }, selection: selection, error: error)
  }
}
