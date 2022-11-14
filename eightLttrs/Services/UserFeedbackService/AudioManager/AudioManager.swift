//
//  AudioManager.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 11.10.22.
//

import AVFoundation
import Foundation

class AudioManager {
  private var player: AVAudioPlayer?

  init(player: AVAudioPlayer? = nil) {
    self.player = player
    setupAVAudioSession()
  }

  private func setupAVAudioSession() {
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(.playback, options: .mixWithOthers)
      try audioSession.setActive(true)
    } catch {
      print(error)
    }
  }

  func play(type: SoundType) {
    do {
      if UserDefaults.standard.bool(forKey: UserDefaults.Keys.enabledSound) {
        player = try AVAudioPlayer(contentsOf: type.fileURL)
        player?.volume = Float(UserDefaults.standard.double(forKey: UserDefaults.Keys.setVolume))
        player?.play()
      }
    } catch {
      print(error.localizedDescription)
    }
  }
}
