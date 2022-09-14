//
//  SessionDetailChartView.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 11.09.22.
//

import Charts
import SwiftUI

struct WordsFoundChartData {
  let score: String
  let wordsFound: Int

  static let possibleScores = [3, 5, 9, 15, 23, 33]
}

struct SessionDetailChartView: View {
  let session: Session

  var avgPoints: String {
    return String(format: "%.02f", session.averagePointsPerWord)
  }

  var data: [WordsFoundChartData] {
    return WordsFoundChartData.possibleScores.map { score in
      return WordsFoundChartData(score: score.description,
                                 wordsFound: session.usedWords.filter { $0.calculatedScore() == score }.count )
    }
  }

  var body: some View {
    VStack(alignment: .leading) {
      ViewThatFits {
        chartHorizontalTitleStack
        chartVerticalTitleStack
      }

      Chart(data, id: \.score) { entry in
        BarMark(x: .value("Scores", entry.score), y: .value("Number of Words found", entry.wordsFound))
          .foregroundStyle(Color.accentColor.gradient)
      }
      .frame(height: 200)
    }
  }
}

struct SessionDetailChartView_Previews: PreviewProvider {
  static var session: Session = SessionService.allObjects(Session.self, in: PersistenceController.preview.context).first!

  static var previews: some View {
    SessionDetailChartView(session: session)
  }
}

extension SessionDetailChartView {
  private var chartTitle: some View {
    Text(L10n.SessionDetailChartView.title)
      .font(.system(.headline, design: .rounded, weight: .semibold))
  }

  private var chartSubtitle: some View {
    Text(L10n.SessionDetailChartView.subtitle(avgPoints))
      .font(.system(.caption, design: .rounded, weight: .semibold))
      .foregroundColor(.secondary)
  }

  private var chartHorizontalTitleStack: some View {
    HStack(alignment: .bottom) {
      chartTitle
      Spacer()
      chartSubtitle
    }
  }

  private var chartVerticalTitleStack: some View {
    VStack(alignment: .leading) {
      chartTitle
      chartSubtitle
    }
  }

  private var chartTitleStack: some View {
    ViewThatFits {
      chartHorizontalTitleStack
      chartVerticalTitleStack
    }
  }
}
