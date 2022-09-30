//
//  ReviewRequestService.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 17.09.22.
//

import Foundation
import StoreKit

final class ReviewRequestService {
  let currentVersion: String
  let lastVersionPromptedForReview: String?
  var currentWordCounter = UserDefaults.standard.integer(forKey: UserDefaultsKeys.wordCounterForRequestKey)
  var neededWordCounter = UserDefaults.standard.integer(forKey: UserDefaultsKeys.neededWordCounterForRequestKey)

  init() {
    if neededWordCounter == 0 { neededWordCounter = 50 }

    let infoDictionaryKey = kCFBundleVersionKey as String
    guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
    else { fatalError("Expected to find a bundle version in the info dictionary") }

    self.currentVersion = currentVersion
    self.lastVersionPromptedForReview = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
  }

  func isReadyForRequest() -> Bool {
    if currentVersion != lastVersionPromptedForReview
        && currentWordCounter >= neededWordCounter {
      return true
    }
    return false
  }

  func incrementCounterForRequest() {
    currentWordCounter += 1
    UserDefaults.standard.setValue(currentWordCounter, forKey: UserDefaultsKeys.wordCounterForRequestKey)
  }

  func bundleVersionHasIncreased() -> Bool {
    return lastVersionPromptedForReview != currentVersion
  }

  func presentReviewRequestIfPossible() {
    guard isReadyForRequest() else { return }

    if let currentScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
      SKStoreReviewController.requestReview(in: currentScene)
      currentWordCounter = 0
      UserDefaults.standard.set(currentVersion, forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
      UserDefaults.standard.set(currentWordCounter, forKey: UserDefaultsKeys.wordCounterForRequestKey)
    }
  }
}
