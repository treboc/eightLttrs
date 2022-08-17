//
//  ScoreService.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 17.08.22.
//

import Foundation

// MARK: - Saving & Loading Scores
struct ScoresOnWord: Codable {
  let word: String
  var playerScores: [PlayerScore]
}

struct PlayerScore: Codable {
  let name: String
  let score: Int
}

class ScoreService {
  var allScores = [ScoresOnWord]()
  let filepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("scores.json")

  init() {
    do {
      let scores = try loadScores()
      self.allScores = scores
    } catch {
      print(error.localizedDescription)
    }
  }

  private func loadScores() throws -> [ScoresOnWord] {
    let data = try Data(contentsOf: filepath)
    return try JSONDecoder().decode([ScoresOnWord].self, from: data)
  }

  func saveScore(word: String, name: String, score: Int) {
    let playerScore = PlayerScore(name: name, score: score)

    // Check if this word already was scored on
    if let index = allScores.firstIndex(where: { $0.word == word }) {
      self.allScores[index].playerScores.append(playerScore)
    } else {
      // if not, create new score to word
      let scoreOnWord = ScoresOnWord(word: word, playerScores: [playerScore])
      self.allScores.append(scoreOnWord)
    }

    writeScoresToDisk()
  }

  private func writeScoresToDisk() {
    do {
      let objects = try JSONEncoder().encode(allScores)
      try objects.write(to: filepath, options: [.atomic])
    } catch {
      print(error.localizedDescription)
    }
  }
}
