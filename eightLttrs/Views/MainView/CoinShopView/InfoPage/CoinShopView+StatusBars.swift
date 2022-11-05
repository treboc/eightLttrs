//
//  CoinShopView+StatusBars.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 05.11.22.
//

import SwiftUI

extension CoinShopView {
  struct InfoPageGauge50Percent: View {
    let session: Session

    private var percentTo50: Double {
      let usedWords = Double(session.usedWords.count)
      let possibleWords = Double(session.possibleWords.count) / 2

      return min(1.0, (usedWords / possibleWords))
    }

    private var wordsTo50: Int {
      let usedWords = session.usedWords.count
      let possibleWords = Int(session.possibleWords.count / 2)

      return possibleWords - usedWords
    }

    var body: some View {
      Gauge(value: percentTo50) {
        Text(percentTo50 >= 1 ? L10n.CoinShopView.InfoPage._50percentReached : L10n.CoinShopInfoPage.to50percent(wordsTo50))
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding()
      .background(Color.black.opacity(0.3), in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
      .overlay(alignment: .topTrailing) {
        if percentTo50 >= 1 {
          Image(systemName: "checkmark.circle.fill")
            .foregroundColor(.green)
            .padding()
        }
      }
    }
  }

  struct InfoPageGauge100Percent: View {
    let session: Session

    private var percentTo100: Double {
      let usedWords = Double(session.usedWords.count)
      let possibleWords = Double(session.possibleWords.count)

      return min(1.0, (usedWords / possibleWords))
    }

    private var wordsTo100: Int {
      let usedWords = session.usedWords.count
      let possibleWords = session.possibleWords.count

      return possibleWords - usedWords
    }

    var body: some View {
      Gauge(value: percentTo100) {
        Text(percentTo100 >= 1 ? L10n.CoinShopView.InfoPage._100percentReached : L10n.CoinShopInfoPage.to100percent(wordsTo100))
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding()
      .background(Color.black.opacity(0.3), in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
      .overlay(alignment: .topTrailing) {
        if percentTo100 >= 1 {
          Image(systemName: "checkmark.circle.fill")
            .foregroundColor(.green)
            .padding()
        }
      }
    }
  }

  struct InfoPageGauge20Words: View {
    let correctWords: Int

    private var wordsLeftPercent: Double {
      return Double(correctWords) / 20
    }

    private var wordsTo20: Int {
      return 20 - correctWords
    }

    var body: some View {
      Gauge(value: wordsLeftPercent) {
        Text(L10n.CoinShopInfoPage.wordsLeft(wordsTo20))
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding()
      .background(Color.black.opacity(0.3), in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
  }
}
