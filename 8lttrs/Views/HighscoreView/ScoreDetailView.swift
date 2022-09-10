//
//  HighscoreDetailView.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 31.08.22.
//

import SwiftUI

struct HighscoreDetailView: View {
  let session: Session
  var body: some View {
    Text(session.unwrappedWord)
  }
}

struct ScoreDetailView_Previews: PreviewProvider {
  static let session = SessionService.allObjects(Session.self, in: PersistenceStore.preview.context).first!

  static var previews: some View {
    HighscoreDetailView(session: session)
  }
}
