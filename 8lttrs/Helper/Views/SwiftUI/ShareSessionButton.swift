//
//  ShareSessionButton.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 08.09.22.
//

import SwiftUI

struct ShareSessionButton: View {
  let session: Session
  var sharableURL: URL {
    if let url = session.sharableURL {
      return url
    } else {
      return URL(string: "worscramble://baseword/wordNotFound")!
    }
  }

  var body: some View {
    ShareLink(item: sharableURL,
              subject: Text("Give it a try!"),
              message: message,
              preview: preview,
              label: label)
    .disabled(session.sharableURL == nil)
  }

  private var preview: SharePreview<Never, Never> {
    SharePreview(L10n.ShareLink.previewMessage(session.unwrappedBaseword))
  }

  private var message: Text {
    Text("\n\(L10n.ShareLink.message(session.unwrappedBaseword))\(L10n.shareSessionMessage(session.usedWords.count, session.score))")
  }

  func label() -> some View {
    HStack {
      Image(systemName: "square.and.arrow.up.circle.fill")
        .font(.system(.title2, design: .rounded, weight: .bold))
      Text(L10n.ButtonTitle.shareSession)
    }
  }
}
