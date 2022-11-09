//
//  AudioPlayer.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 11.10.22.
//

import AVFoundation
import Foundation

final class AudioPlayer {
  private var player: AVAudioPlayer?
  
  func play(type: SoundType) {
    do {
      if UserDefaults.standard.bool(forKey: UserDefaultsKeys.enabledSound) {
        try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
        try AVAudioSession.sharedInstance().setActive(true)
        player = try AVAudioPlayer(contentsOf: type.fileURL)
        player?.volume = Float(UserDefaults.standard.double(forKey: UserDefaultsKeys.setVolume))
        player?.play()
      }
    } catch {
      print(error.localizedDescription)
    }
  }
}
