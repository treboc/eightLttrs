//
//  SessionDetailView.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 31.08.22.
//

import SwiftUI

struct SessionDetailView: View {
  @EnvironmentObject private var viewModel: MainViewModel
  @Environment(\.modalMode) private var modalMode
  @Environment(\.editMode) private var editMode
  @State private var alertModel: AlertToPresent? = nil

  @ObservedObject var session: Session

  var body: some View {
    Form {
      Section {
        nameField
        HStack {
          Text(L10n.HighscoreDetaiLView.baseword)
            .foregroundColor(.secondary)
          Spacer()
          Text(session.unwrappedBaseword)
        }
        
        HStack {
          Text(L10n.HighscoreDetaiLView.score)
            .foregroundColor(.secondary)
          Spacer()
          Text("\(session.score) / \(session.maxPossibleScoreOnBaseWord)")
        }
      }

      Section {
        Button(action: retrySession) {
          HStack {
            Image(systemName: "arrow.counterclockwise.circle.fill")
              .font(.system(.title2, design: .rounded, weight: .bold))
            Text(L10n.HighscoreDetailView.tryAgain)
          }
        }

        ShareSessionButton(session: session)
      }
      .disabled(session.baseword == nil)
      .presentAlert(with: $alertModel)

      Section(L10n.HighscoreDetailView.statistics) {
        SessionDetailChartView(session: session)
      }
      
      Section(session.usedWords.count > 0
              ? L10n.HighscoreDetaiLView.foundWordsPercentage(session.percentageWordsFoundString)
              : "") {
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
    .toolbar {
      EditButton()
        .disabled(nameIsValid == false)
    }
    .navigationTitle(L10n.HighscoreDetailView.title)
    .roundedNavigationTitle()
  }
}

struct ScoreDetailView_Previews: PreviewProvider {
  static let session = SessionService.allObjects(Session.self, in: PersistenceStore.preview.context).first!
  
  static var previews: some View {
    NavigationView {
      SessionDetailView(session: session)
        .preferredColorScheme(.dark)
    }
  }
}

extension SessionDetailView {
  private func retrySession() {
    if viewModel.session.usedWords.isEmpty {
      viewModel.startNewSession(with: session.unwrappedBaseword)
      modalMode.wrappedValue = false
    } else {
      alertModel = AlertToPresent(title: L10n.ResetGameAlert.title,
                                       message: L10n.ResetGameAlert.message) {
        viewModel.startNewSession(with: session.unwrappedBaseword)
        modalMode.wrappedValue = false
      }
    }
  }

  private func isEditingChanged(_ isEditing: Bool) {
    if isEditing == false {
      do {
        try PersistenceStore.shared.context.save()
      } catch {
        alertModel = AlertToPresent(simpleAlert: true, title: "Error", message: "Sorry, an error occurred while saving the session.") {}
        PersistenceStore.shared.context.rollback()
      }
    }
  }

  private func rollbackOnDisappear() {
    if session.hasChanges {
      PersistenceStore.shared.context.rollback()
    }
  }
}

extension SessionDetailView {
  private var isEditing: Bool {
    return editMode?.wrappedValue.isEditing == true
  }

  private var nameIsValid: Bool {
    return session.unwrappedName
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .isEmpty == false
  }

  @ViewBuilder
  private var nameField: some View {
    HStack {
      if editMode?.wrappedValue.isEditing == true {
        TextField("Name", text: $session.unwrappedName)
          .autocorrectionDisabled()
          .keyboardType(.namePhonePad)
      } else {
        Text(L10n.HighscoreDetaiLView.name)
          .foregroundColor(.secondary)
        Spacer()
        Text(session.unwrappedName)
      }
    }
    .animation(.none, value: editMode?.wrappedValue)
    .onChange(of: isEditing, perform: isEditingChanged)
    .onDisappear(perform: rollbackOnDisappear)
  }
}
