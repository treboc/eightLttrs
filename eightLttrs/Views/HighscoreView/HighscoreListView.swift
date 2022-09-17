//
//  HighscoreListView.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 31.08.22.
//

import SwiftUI

struct HighscoreListView: View {
  @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isFinished = %d", true))
  private var sessions: FetchedResults<Session>

  var body: some View {
    Group {
      if sessions.isEmpty {
        emptyListPlaceholder()
      } else {
        List {
          ForEach(Array(zip(sessions.indices, sessions.sorted(by: highscore))), id: \.0) { index, session in
            HighscoreListRowView(rank: index + 1, session: session)
          }
        }
        .listStyle(.plain)
      }
    }
    .navigationTitle(L10n.HighscoreListView.title)
    .roundedNavigationTitle()
  }

  private func highscore(_ lhs: Session, _ rhs: Session) -> Bool {
    lhs.score > rhs.score
  }
}

struct HighscoreListView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      HighscoreListView()
        .environment(\.managedObjectContext, PersistenceController.preview.context)
    }
    .preferredColorScheme(.dark)
  }
}

struct emptyListPlaceholder: View {
  var body: some View {
    VStack(spacing: 20) {
      Text(L10n.HighscoreListEmptyListPlaceholder.title)
        .font(.system(.title2, design: .rounded, weight: .bold))
      Text(L10n.HighscoreListEmptyListPlaceholder.body)
        .font(.system(.body, design: .rounded, weight: .semibold))
      Spacer()
    }
    .multilineTextAlignment(.center)
    .padding(50)
  }
}
