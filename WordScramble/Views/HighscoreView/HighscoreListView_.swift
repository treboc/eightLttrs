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
    List {
      ForEach(Array(zip(sessions.indices, sessions)), id: \.0) { index, session in
        HighscoreListRowView(rank: index + 1, session: session)
      }
      .listRowSeparator(.hidden)
    }
    .listStyle(.plain)
    .navigationTitle(L10n.HighscoreView.title)
    .roundedNavigationTitle()
  }
}


struct HighscoreListView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      HighscoreListView()
        .environment(\.managedObjectContext, PersistenceStore.preview.context)
    }
    .preferredColorScheme(.dark)
  }
}

struct HighscoreListRowView: View {
  let rank: Int
  let session: Session

  var body: some View {
    HStack(alignment: .center) {
      Text("\(rank).")
        .font(.headline)
        .fontWeight(.semibold)
        .frame(width: 30, alignment: .center)

      VStack(alignment: .leading) {
        Text(session.unwrappedName)

        Group {
          Text("gesucht war: ")
          + Text(session.unwrappedBaseword)
            .italic()
        }
        .font(.caption2)
        .foregroundColor(.secondary)
      }

      Spacer()

      VStack(alignment: .trailing) {
        Text("\(session.score)")
        Text("Punkte")
          .font(.caption2)
          .foregroundColor(.secondary)
      }

      Image(systemName: "chevron.right")
        .padding(.leading, 5)
    }
    .padding(8)
    .frame(maxWidth: .infinity)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5))
    .background(NavigationLink("", destination: HighscoreDetailView(session: session)).opacity(0).buttonStyle(.plain))
  }
}
