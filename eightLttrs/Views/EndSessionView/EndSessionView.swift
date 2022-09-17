//
//  EndSessionView.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 07.09.22.
//

import SwiftUI

struct EndSessionView: View {
  @Environment(\.modalMode) private var modalMode
  @ObservedObject var session: Session
  @FocusState private var isFocused
  @AppStorage(UserDefaultsKeys.lastPlayersName) private var name: String = ""

  var body: some View {
    Form {
      Section {
        Text(L10n.EndSessionView.title)
          .font(.system(.title, design: .rounded))
          .fontWeight(.semibold)
          .foregroundColor(.accent)
          .padding(.bottom)

        Text(L10n.endSessionBody(session.usedWords.count, session.score))
      }
      .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
      .listRowBackground(Color.clear)
      .listRowSeparator(.hidden)

      Section {
        TextField("Name", text: $name)
          .focused($isFocused)
          .onAppear { isFocused.toggle() }

        Button(L10n.ButtonTitle.save) {
          SessionService.persistFinished(session: session, forPlayer: name)
          modalMode.wrappedValue = false
        }
        .disabled(name.isEmpty)

        Button(L10n.ButtonTitle.cancel, role: .destructive) { modalMode.wrappedValue = false }
      }

      Section(L10n.possibleWords) {
        PossibleWordList(possibleWords: session.possibleWords,
                         usedWords: session.usedWords)
      }
    }
    .interactiveDismissDisabled()
    .scrollIndicators(.hidden)
  }
}

struct EndSessionView_Previews: PreviewProvider {
  static let session: Session = SessionService.allObjects(Session.self, in: PersistenceController.preview.context).first!

  static var previews: some View {
    EndSessionView(session: session)
      .preferredColorScheme(.dark)
      .previewDevice("iPhone 12 mini")
  }
}
