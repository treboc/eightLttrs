//
//  MenuView-SwiftUI.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 28.08.22.
//

import UIKit
import SwiftUI

struct AlertToPresent {
  let title: String
  let message: String
  let primaryActionTitle: String = L10n.ButtonTitle.imSure
  let primaryAction: () -> Void
}

struct MenuView_SwiftUI: View {
  // Properties
  let gameService: GameServiceProtocol
  @Environment(\.dismiss) private var dismiss

  // UserDefaults
  @AppStorage(UserDefaultsKeys.enabledVibration) private var enabledVibration = true
  @AppStorage(UserDefaultsKeys.enabledSound) private var enabledSound = true

  @State private var alertModel: AlertToPresent? = nil
  @State private var endGameViewIsShown: Bool = false

  var body: some View {
    NavigationView {
      Form {
        Section {
          Button(L10n.MenuView.restartSession, action: restartSession)

          Button(L10n.MenuView.endSession, action: endSession)
            .disabled(gameService.usedWords.isEmpty)

          NavigationLink(L10n.MenuView.showHighscore) {
            HighscoresViewRepresentable()
              .navigationTitle("Highscores")
          }
          .buttonStyle(.borderedProminent)
        }

        Section("Settings") {
          Toggle(isOn: $enabledVibration) {
            Label("Vibration", systemImage: "waveform.circle.fill")
              .labelStyle(.titleAndIcon)
          }

          Toggle(isOn: $enabledSound) {
            Label("Sound", systemImage: enabledSound ? "speaker.circle" : "speaker.slash.circle")
              .animation(.default, value: enabledSound)
              .labelStyle(.titleAndIcon)
          }
        }

        #if DEBUG
        Section("Development") {
          Button("Reset first start") { UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isFirstStart) }
        }
        #endif
      }
      .sheet(isPresented: $endGameViewIsShown, onDismiss: endGameViewDismissed) {
        EndSessionViewControllerRepresentable(gameService: gameService)
      }
      .presentAlert(with: $alertModel)
      .navigationTitle(L10n.MenuView.title)
      .roundedNavigationTitle()
    }
  }
}

extension MenuView_SwiftUI {
  private func restartSession() {
    if !gameService.usedWords.isEmpty {
      self.alertModel = AlertToPresent(title: L10n.ResetGameAlert.title,
                                       message: L10n.ResetGameAlert.message) {
        gameService.startGame()
        dismiss.callAsFunction()
      }
    } else {
      gameService.startGame()
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
    gameService.startGame()
  }
}



