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

  var data: [WordsFoundChartData] {

    return WordsFoundChartData.possibleScores.map { score in
      return WordsFoundChartData(score: score.description,
                                 wordsFound: session.usedWords.filter { $0.calculatedScore() == score }.count )
    }
  }

  var body: some View {
    Chart(data, id: \.score) { entry in
      BarMark(x: .value("Scores", entry.score), y: .value("Number of Words found", entry.wordsFound))
        .foregroundStyle(Color.accentColor.gradient)
    }
    .frame(height: 200)
  }
}

struct SessionDetailChartView_Previews: PreviewProvider {
  static var session: Session = SessionService.allObjects(Session.self, in: PersistenceController.preview.context).first!

  static var previews: some View {
    SessionDetailChartView(session: session)
  }
}
