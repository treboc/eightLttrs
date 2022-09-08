//
//  MenuView.swift
//  WordScramble
//

import UIKit
import SwiftUI

struct MenuView: View {
  // Properties
  let mainViewModel: MainViewModel
  @Environment(\.dismiss) private var dismiss

  // UserDefaults
  @AppStorage(UserDefaultsKeys.enabledVibration) private var enabledVibration = true
  @AppStorage(UserDefaultsKeys.enabledSound) private var enabledSound = true
  @AppStorage(UserDefaultsKeys.enabledFiltering) private var enabledFiltering = true
  @AppStorage(UserDefaultsKeys.regionCode) private var chosenBasewordLocale: WSLocale = .DE

  @State private var alertModel: AlertToPresent? = nil
  @State private var endGameViewIsShown: Bool = false

  var body: some View {
    NavigationView {
      Form {
        Section {
          Button(L10n.MenuView.restartSession, action: restartSession)

          Button(L10n.MenuView.endSession, action: endSession)
            .disabled(mainViewModel.session.usedWords.isEmpty)

          NavigationLink(L10n.MenuView.showHighscore) {
            HighscoreListView()
              .environment(\.managedObjectContext, PersistenceStore.shared.context)
          }
          .buttonStyle(.borderedProminent)
        }

        Section {
          Picker(selection: $chosenBasewordLocale) {
            ForEach(WSLocale.availableLanguages()) { locale in
              Text(locale.description)
                .tag(locale)
            }
          } label: {
            Label(L10n.MenuView.baseword, systemImage: "book.circle")
              .labelStyle(.titleAndIcon)
          }

          Toggle(isOn: $enabledVibration) {
            Label(L10n.MenuView.hapticFeedback, systemImage: "waveform.circle")
              .labelStyle(.titleAndIcon)
          }

          Toggle(isOn: $enabledSound) {
            Label(L10n.MenuView.sound, systemImage: enabledSound ? "speaker.circle" : "speaker.slash.circle")
              .labelStyle(.titleAndIcon)
          }

          Toggle(isOn: $enabledFiltering) {
            Label(L10n.MenuView.filter, systemImage: "magnifyingglass.circle")
              .labelStyle(.titleAndIcon)
          }
        } header: {
          Text(L10n.MenuView.settings)
        } footer: {
          Text(L10n.MenuView.filterDescription)
        }
        .tint(.accentColor)

        #if DEBUG
        Section("Development") {
          Button("Reset first start") {
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isFirstStart)
            dump(UserDefaults.standard.object(forKey: UserDefaultsKeys.isFirstStart))
          }
        }

        allPossibleWordsSection_DEV

        #endif
      }
      .sheet(isPresented: $endGameViewIsShown, onDismiss: endGameViewDismissed) {
        EndSessionView(session: mainViewModel.session)
      }
      .toolbar {
        ToolbarItem {
          Button(action: dismiss.callAsFunction) {
            Label("Close", systemImage: "x.circle.fill")
              .foregroundColor(.accentColor)
          }
        }
      }
      .presentAlert(with: $alertModel)
      .navigationTitle(L10n.MenuView.title)
      .roundedNavigationTitle()
    }
    .navigationViewStyle(.stack)
  }
}

#if DEBUG
// MARK: - Views
extension MenuView {
  private var allPossibleWordsSection_DEV: some View {
    Section("Possible words for \(mainViewModel.session.unwrappedBaseword)") {
      List {
        ForEach(Array(mainViewModel.session.possibleWords).sorted(), id: \.self) { word in
          HStack {
            Text(word)
              .strikethrough(mainViewModel.session.usedWords.contains(word), color: .accentColor)

            Spacer()

            mainViewModel.session.usedWords.contains(word)
            ? Image(systemName: "checkmark.circle")
            : Image(systemName: "circle")
          }
        }
      }
    }
  }
}
#endif

// MARK: - Methods
extension MenuView {
  private func restartSession() {
    if !mainViewModel.session.usedWords.isEmpty {
      self.alertModel = AlertToPresent(title: L10n.ResetGameAlert.title,
                                       message: L10n.ResetGameAlert.message) {
        mainViewModel.startNewSession()
        dismiss.callAsFunction()
      }
    } else {
      mainViewModel.startNewSession()
      dismiss.callAsFunction()
    }
  }

  private func endSession() {
    self.alertModel = AlertToPresent(title: L10n.EndGameAlert.title,
                                     message: L10n.EndGameAlert.message) {
      endGameViewIsShown.toggle()
    }
  }

  private func endGameViewDismissed() {
    dismiss.callAsFunction()
    mainViewModel.startNewSession()
  }
}



