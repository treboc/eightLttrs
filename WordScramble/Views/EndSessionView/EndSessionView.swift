//
//  EndSessionView.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 07.09.22.
//

import SwiftUI

struct EndSessionView: View {
  @Environment(\.dismiss) private var dismiss
  @ObservedObject var session: Session
  @AppStorage(UserDefaultsKeys.lastPlayersName) private var name: String = ""

  var body: some View {
    VStack(spacing: 10) {
      Text(L10n.EndSessionView.title)
        .font(.system(.title, design: .rounded))
        .fontWeight(.semibold)
        .foregroundColor(.accent)

      Text(L10n.Words.count(session.usedWords.count))

      Text(L10n.EndSessionView.body(session.score))

      TextField("Name", text: $name)
        .padding(10)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 100)
        .padding(.vertical, 50)

      HStack {
        Button("Cancel", role: .destructive, action: dismiss.callAsFunction)
        Button("Save") {
          SessionService.persistFinished(session: session, forPlayer: name)
          dismiss()
        }
        .disabled(name.isEmpty)
      }
      .buttonStyle(.bordered)
      .controlSize(.regular)
    }
    .multilineTextAlignment(.center)
  }
}

struct EndSessionView_Previews: PreviewProvider {
  static let session: Session = SessionService.allObjects(Session.self, in: PersistenceStore.preview.context).first!

  static var previews: some View {
    EndSessionView(session: session)
  }
}
