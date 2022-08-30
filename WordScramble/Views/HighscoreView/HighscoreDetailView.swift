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
          Text("Name")
            .foregroundColor(.secondary)
          Spacer()
          Text(session.unwrappedName)
        }
        
        HStack {
          Text("Startword")
            .foregroundColor(.secondary)
          Spacer()
          Text(session.unwrappedWord)
        }
        
        HStack {
          Text("Score")
            .foregroundColor(.secondary)
          Spacer()
          Text("\(session.score) / \(session.possibleWordsScore)")
        }
      }
      
      Section("Found \(session.percentageWordsFoundString) words") {
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
    .navigationTitle("Statistics")
    .roundedNavigationTitle()
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
