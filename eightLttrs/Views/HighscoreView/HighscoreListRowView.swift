//
//  HighscoreListRowView.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 08.09.22.
//

import SwiftUI

struct HighscoreListRowView: View {
  @Environment(\.dynamicTypeSize) private var dynamicTypeSize
  let rank: Int
  @ObservedObject var session: Session

  var body: some View {
    Group {
      if dynamicTypeSize.isAccessibilitySize {
        accessibilityLayout
      } else {
        regularLayout
      }
    }
    .background(
      NavigationLink("", destination: SessionDetailView(session: session))
        .opacity(0)
        .buttonStyle(.plain)
        .accessibilityIdentifier("highscoreListRowNavLink")
    )
    .accessibilityElement()
    .accessibilityLabel("\(rank)., \(session.unwrappedName), \(session.score) Points")
  }
}

struct HighscoreListRowView_Previews: PreviewProvider {
  static var session = SessionService.allObjects(Session.self, in: PersistenceController.preview.context).first!

  static var previews: some View {
    Group {
      HighscoreListRowView(rank: 1, session: session)
        .padding(50)
        .previewLayout(.sizeThatFits)

      HighscoreListRowView(rank: 1, session: session)
        .padding(50)
        .previewLayout(.sizeThatFits)
        .environment(\.dynamicTypeSize, .accessibility4)
    }
  }
}

extension HighscoreListRowView {
  private var accessibilityLayout: some View {
    HStackLayout(alignment: .center, spacing: 20) {
      Text("\(rank).")
        .lineLimit(1)
        .font(.headline)
        .fontWeight(.semibold)

      VStack(alignment: .leading) {
        Text(session.unwrappedName)
        Text(String(format: "\(L10n.score): %i", session.score))
          .font(.caption2)
          .foregroundColor(.secondary)
      }
    }
  }

  private var regularLayout: some View {
    HStackLayout(alignment: .center) {
      Text("\(rank).")
        .font(.headline)
        .fontWeight(.semibold)
        .frame(width: 30, alignment: .center)

      VStack(alignment: .leading) {
        Text(session.unwrappedName)


        Text(LocalizedStringKey(L10n.HighscoreListRowView.basewordWas(session.unwrappedBaseword)))
          .font(.caption2)
          .foregroundColor(.secondary)
      }

      Spacer()

      VStack(alignment: .trailing) {
        Text("\(session.score)")
        Text(L10n.score)
          .font(.caption2)
          .foregroundColor(.secondary)
      }

      Image(systemName: "chevron.right")
        .padding(.leading, 5)
    }
  }
}
