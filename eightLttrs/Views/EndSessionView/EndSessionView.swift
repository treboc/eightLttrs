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
    VStack {
      VStack(spacing: 30) {
        Text(L10n.EndSessionView.title)
          .font(.system(.title, design: .rounded))
          .fontWeight(.semibold)
          .foregroundColor(.accent)

        Text(L10n.endSessionBody(session.usedWords.count, session.score))
      }

      TextField("Name", text: $name)
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal, 100)
        .padding(.vertical, 50)
        .focused($isFocused)
        .onAppear { isFocused.toggle() }

      HStack {
        Button(L10n.ButtonTitle.cancel, role: .destructive) { modalMode.wrappedValue = false }
        Button(L10n.ButtonTitle.save) {
          SessionService.persistFinished(session: session, forPlayer: name)
          modalMode.wrappedValue = false
        }
        .disabled(name.isEmpty)
      }
      .frame(maxWidth: .infinity)
      .buttonStyle(.bordered)
      .controlSize(.large)
      .fixedSize(horizontal: true, vertical: false)
    }
    .multilineTextAlignment(.center)
    .interactiveDismissDisabled()
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
