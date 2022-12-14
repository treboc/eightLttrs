//
//  CoinShopManager.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 31.10.22.
//

import Combine
import Foundation

final class CoinShopManager: ObservableObject {
  enum CoinShopKeys: String {
    case availableCoins
    case correctWordsEntered
  }

  var cancellables = Set<AnyCancellable>()
  static let shared = CoinShopManager()

  @Published private(set) var availableCoins: Int = 0
  @Published private(set) var correctWordsEntered: Int = 0

  private init() {
    registerKeys()
    loadValues()

    $availableCoins
      .dropFirst()
      .sink { [unowned self] _ in
        self.saveValues()
      }
      .store(in: &cancellables)

    $correctWordsEntered
      .dropFirst()
      .sink { [unowned self] _ in
        self.saveValues()
      }
      .store(in: &cancellables)
  }

  private func registerKeys() {
    UserDefaults.standard.register(defaults: [
      Self.CoinShopKeys.availableCoins.rawValue: 0,
      Self.CoinShopKeys.correctWordsEntered.rawValue: 0,
    ])
  }
}

extension CoinShopManager {
  enum BuyOption: Int {
    case one, three, five

    var amount: Int {
      switch self {
      case .one:
        return 1
      case .three:
        return 3
      case .five:
        return 5
      }
    }

    var price: Int {
      switch self {
      case .one:
        return 15
      case .three:
        return 25
      case .five:
        return 37
      }
    }

    func canBuyAmount(wordsLeft: Int, availableCoins: Int) -> Bool {
      switch self {
      case .one:
        return wordsLeft >= 1 && availableCoins >= BuyOption.one.price
      case .three:
        return wordsLeft >= 3 && availableCoins >= BuyOption.three.price
      case .five:
        return wordsLeft >= 5 && availableCoins >= BuyOption.five.price
      }
    }
  }

  enum GetCoins: Int {
    case twentyWords = 20
    case wordHalfwayThrough = 40
    case wordCompleted = 90
  }

  func enteredCorrectWord(on session: Session) {
    if correctWordsEntered == 20 {
      increaseCoins(by: .twentyWords)
      correctWordsEntered = 0
    } else {
      correctWordsEntered += 1
    }

    if (Double(session.usedWords.count) / Double(session.possibleWordsSet.count)) >= 0.5 && !session.fiftyPercentReached {
      increaseCoins(by: .wordHalfwayThrough)
      session.fiftyPercentReached = true
    }

    if session.usedWords.count == session.possibleWordsSet.count {
      increaseCoins(by: .wordCompleted)
    }
  }

  func buy(option: BuyOption, for session: Session) -> Result<Int, Error> {
    do {
      try addBoughtWords(option.amount, session: session)
      availableCoins -= option.price

      if session.usedWords.count == session.possibleWords.count {
        increaseCoins(by: .wordCompleted)
      }

      if (Double(session.usedWords.count) / Double(session.possibleWordsSet.count)) >= 0.5 && !session.fiftyPercentReached {
        increaseCoins(by: .wordHalfwayThrough)
        session.fiftyPercentReached = true
      }

      return .success(option.amount)
    } catch let error {
      return .failure(error)
    }
  }

  private func addBoughtWords(_ amount: Int, session: Session) throws {
    for _ in 0..<amount {
      guard let randomWord = WordService.getRandomWord(for: session) else { throw CoinShopError.addingWords }
      session.usedWords.insert(randomWord, at: 0)
    }

    session.score = GameService.calculatedScore(for: session.usedWords)
    SessionService.persist(session: session)
  }
}

extension CoinShopManager {
  private func increaseCoins(by coins: GetCoins) {
    let currentCoins = availableCoins + coins.rawValue
    availableCoins = currentCoins
  }

  func canBuyWord(_ session: Session) -> Bool {
    let wordsAvailable: Bool = session.usedWords.count < session.possibleWordsSet.count

    return availableCoins >= 15 && wordsAvailable
  }
}

extension CoinShopManager {
  private func saveValues() {
    UserDefaults.standard.set(self.correctWordsEntered, forKey: CoinShopKeys.correctWordsEntered.rawValue)
    UserDefaults.standard.set(self.availableCoins, forKey: CoinShopKeys.availableCoins.rawValue)
  }

  private func loadValues() {
    self.availableCoins = UserDefaults.standard.integer(forKey: CoinShopKeys.availableCoins.rawValue)
    self.correctWordsEntered = UserDefaults.standard.integer(forKey: CoinShopKeys.correctWordsEntered.rawValue)
  }
}

extension CoinShopManager {
  enum CoinShopError: Error {
    case missingCoins(Int)
    case gettingWord
    case addingWords
  }
}
