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
    Form {
      Section {
        HStack {
          Text(L10n.HighscoreDetaiLView.name)
            .foregroundColor(.secondary)
          Spacer()
          Text(session.unwrappedName)
        }
        
        HStack {
          Text(L10n.HighscoreDetaiLView.baseword)
            .foregroundColor(.secondary)
          Spacer()
          Text(session.unwrappedWord)
        }
        
        HStack {
          Text(L10n.HighscoreDetaiLView.score)
            .foregroundColor(.secondary)
          Spacer()
          Text("\(session.score) / \(session.maxPossibleScoreOnBaseWord)")
        }
      }
      
      Section(L10n.HighscoreDetaiLView.foundWordsPercentage(session.percentageWordsFound)) {
        List {
          ForEach(session.usedWords, id: \.self) { word in
            HStack {
              Image(systemName: "\(word.calculatedScore()).circle.fill")
                .foregroundColor(.accentColor)
              
              Text(word)
            }
          }
        }
      }
    }
  }
}

struct ScoreDetailView_Previews: PreviewProvider {
  static let session = SessionService.allObjects(Session.self, in: PersistenceStore.preview.context).first!
  
  static var previews: some View {
    NavigationView {
      HighscoreDetailView(session: session)
        .preferredColorScheme(.dark)
    }
  }
}
