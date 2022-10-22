//
//  SessionDetailView.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 31.08.22.
//

import CoreData
import SwiftUI

struct SessionDetailView: View {
  @EnvironmentObject private var viewModel: MainViewModel
  @Environment(\.modalMode) private var modalMode
  @State private var alertModel: AlertToPresent? = nil
  let session: Session

  var body: some View {
    Form {
      Section {
        nameRow
        basewordRow
        scoreRow
      }

      Section {
        Button(action: retrySession) {
          HStack {
            Image(systemName: "arrow.counterclockwise.circle.fill")
              .font(.system(.title2, design: .rounded, weight: .bold))
            Text(L10n.HighscoreDetailView.tryAgain)
          }
        }

        ShareSessionButton(session: session)
      }
      .disabled(session.baseword == nil)
      .presentAlert(with: $alertModel)

      Section {
        SessionDetailChartView(session: session)
      }
      
      Section(L10n.HighscoreDetaiLView.foundWordsPercentage(session.percentageWordsFoundString)) {
        List {
          ForEach(session.usedWords, id: \.self) { word in
            HStack {
              Image(systemName: "\(word.calculatedScore()).circle.fill")
                .foregroundColor(.accentColor)
              
              Text(word)
            }
            .accessibilityElement()
            .accessibilityLabel(L10n.A11y.MainView.Cell.label(word, word.calculatedScore()))
          }
        }
      }
    }
    .navigationTitle(L10n.HighscoreDetailView.title)
    .roundedNavigationTitle()
  }
}

struct ScoreDetailView_Previews: PreviewProvider {
  static let session = SessionService.allObjects(Session.self, in: PersistenceController.preview.context).first!
  
  static var previews: some View {
    NavigationView {
      SessionDetailView(session: session)
        .preferredColorScheme(.dark)
    }
  }
}

extension SessionDetailView {
  private func retrySession() {
    if viewModel.session.usedWords.isEmpty {
      viewModel.startNewSession(with: session.unwrappedBaseword)
      modalMode.wrappedValue = false
    } else {
      alertModel = AlertToPresent(title: L10n.ResetGameAlert.title,
                                       message: L10n.ResetGameAlert.message) {
        viewModel.startNewSession(with: session.unwrappedBaseword)
        modalMode.wrappedValue = false
      }
    }
  }
}

extension SessionDetailView {
  private var nameRow: some View {
    HStack {
      Text(L10n.HighscoreDetaiLView.name)
        .foregroundColor(.secondary)
      Spacer()
      Text(session.unwrappedName)
    }
    .accessibilityElement()
    .accessibilityLabel("\(L10n.HighscoreDetaiLView.name), \(session.unwrappedName)")
  }

  private var basewordRow: some View {
    HStack {
      Text(L10n.HighscoreDetaiLView.baseword)
        .foregroundColor(.secondary)
      Spacer()
      Text(session.unwrappedBaseword)
    }
    .accessibilityElement()
    .accessibilityLabel("\(L10n.HighscoreDetaiLView.baseword), \(session.unwrappedBaseword)")
  }

  private var scoreRow: some View {
    HStack {
      Text(L10n.HighscoreDetaiLView.score)
        .foregroundColor(.secondary)
      Spacer()
      Text("\(session.score) / \(session.maxPossibleScoreOnBaseWord)")
    }
    .accessibilityElement()
    .accessibilityLabel("\(L10n.HighscoreDetaiLView.score), \(L10n.A11y.SessionDetailView.score(session.score, session.maxPossibleScoreOnBaseWord))")
  }
}
