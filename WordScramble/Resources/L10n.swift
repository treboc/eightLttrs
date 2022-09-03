// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// baseword
  internal static let baseword = L10n.tr("Localizable", "baseword", fallback: "baseword")
  /// basewords
  internal static let basewords = L10n.tr("Localizable", "basewords", fallback: "basewords")
  /// English
  internal static let english = L10n.tr("Localizable", "english", fallback: "English")
  /// Localizable.strings
  ///  WordScramble
  /// 
  ///  Created by Marvin Lee Kobert on 18.08.22.
  internal static let german = L10n.tr("Localizable", "german", fallback: "German")
  /// last added
  internal static let lastAdded = L10n.tr("Localizable", "lastAdded", fallback: "last added")
  internal enum ButtonTitle {
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "ButtonTitle.cancel", fallback: "Cancel")
    /// Continue
    internal static let `continue` = L10n.tr("Localizable", "ButtonTitle.continue", fallback: "Continue")
    /// Yes, I'm sure
    internal static let imSure = L10n.tr("Localizable", "ButtonTitle.imSure", fallback: "Yes, I'm sure")
    /// Next
    internal static let next = L10n.tr("Localizable", "ButtonTitle.next", fallback: "Next")
    /// OK
    internal static let ok = L10n.tr("Localizable", "ButtonTitle.ok", fallback: "OK")
    /// Save
    internal static let save = L10n.tr("Localizable", "ButtonTitle.save", fallback: "Save")
    /// Skip
    internal static let skip = L10n.tr("Localizable", "ButtonTitle.skip", fallback: "Skip")
    /// Submit
    internal static let submit = L10n.tr("Localizable", "ButtonTitle.submit", fallback: "Submit")
  }
  internal enum EndGameAlert {
    /// Are you sure, you don't know any other words?
    internal static let message = L10n.tr("Localizable", "endGameAlert.message", fallback: "Are you sure, you don't know any other words?")
    /// Saving
    internal static let title = L10n.tr("Localizable", "endGameAlert.title", fallback: "Saving")
  }
  internal enum EndSessionView {
    /// You have reached %@ points.
    internal static func body(_ p1: Any) -> String {
      return L10n.tr("Localizable", "endSessionView.body", String(describing: p1), fallback: "You have reached %@ points.")
    }
    /// Congratulations! 🎉
    internal static let title = L10n.tr("Localizable", "endSessionView.title", fallback: "Congratulations! 🎉")
  }
  internal enum HighscoreDetaiLView {
    /// Baseword
    internal static let baseword = L10n.tr("Localizable", "highscoreDetaiLView.baseword", fallback: "Baseword")
    /// Found %@ %
    internal static func foundWordsPercentage(_ p1: Any) -> String {
      return L10n.tr("Localizable", "highscoreDetaiLView.foundWordsPercentage", String(describing: p1), fallback: "Found %@ %")
    }
    /// Name
    internal static let name = L10n.tr("Localizable", "highscoreDetaiLView.name", fallback: "Name")
    /// Score
    internal static let score = L10n.tr("Localizable", "highscoreDetaiLView.score", fallback: "Score")
  }
  internal enum HighscoreView {
    /// Try it yourself!
    internal static let metaDataTitle = L10n.tr("Localizable", "highscoreView.metaDataTitle", fallback: "Try it yourself!")
    /// Highscores
    internal static let title = L10n.tr("Localizable", "highscoreView.title", fallback: "Highscores")
    internal enum ShareScore {
      /// Hey look, I've scored %@ points on "%@"!
      /// Try it and see if you can beat this!
      internal static func text(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "highscoreView.shareScore.text", String(describing: p1), String(describing: p2), fallback: "Hey look, I've scored %@ points on \"%@\"!\nTry it and see if you can beat this!")
      }
    }
  }
  internal enum MainView {
    /// Current Score
    internal static let currentScore = L10n.tr("Localizable", "mainView.currentScore", fallback: "Current Score")
    /// Words found
    internal static let foundWords = L10n.tr("Localizable", "mainView.foundWords", fallback: "Words found")
  }
  internal enum MenuView {
    /// Baseword
    internal static let baseword = L10n.tr("Localizable", "menuView.baseword", fallback: "Baseword")
    /// End Session
    internal static let endSession = L10n.tr("Localizable", "menuView.endSession", fallback: "End Session")
    /// Filter Used Words
    internal static let filter = L10n.tr("Localizable", "menuView.filter", fallback: "Filter Used Words")
    /// When enabled, the list of already used words gets dynamically filtered.
    internal static let filterDescription = L10n.tr("Localizable", "menuView.filterDescription", fallback: "When enabled, the list of already used words gets dynamically filtered.")
    /// Haptic Feedback
    internal static let hapticFeedback = L10n.tr("Localizable", "menuView.hapticFeedback", fallback: "Haptic Feedback")
    /// Restart Session
    internal static let restartSession = L10n.tr("Localizable", "menuView.restartSession", fallback: "Restart Session")
    /// Settings
    internal static let settings = L10n.tr("Localizable", "menuView.settings", fallback: "Settings")
    /// Show Highscore
    internal static let showHighscore = L10n.tr("Localizable", "menuView.showHighscore", fallback: "Show Highscore")
    /// Sound
    internal static let sound = L10n.tr("Localizable", "menuView.sound", fallback: "Sound")
    /// Menu
    internal static let title = L10n.tr("Localizable", "menuView.title", fallback: "Menu")
  }
  internal enum Onboarding {
    internal enum FirstPage {
      /// based on a project of 100daysOfSwift by Paul Hudson
      internal static let body1 = L10n.tr("Localizable", "onboarding.firstPage.body1", fallback: "based on a project of 100daysOfSwift by Paul Hudson")
      /// try to find as many words as possible out of a random starting word
      internal static let body2 = L10n.tr("Localizable", "onboarding.firstPage.body2", fallback: "try to find as many words as possible out of a random starting word")
      /// What's the game about?
      internal static let title = L10n.tr("Localizable", "onboarding.firstPage.title", fallback: "What's the game about?")
    }
    internal enum SecondPage {
      /// all starting words are eight letters long
      internal static let body1 = L10n.tr("Localizable", "onboarding.secondPage.body1", fallback: "all starting words are eight letters long")
      /// your word must contain at least a minimum of three letters
      internal static let body2 = L10n.tr("Localizable", "onboarding.secondPage.body2", fallback: "your word must contain at least a minimum of three letters")
      /// Rules
      internal static let title = L10n.tr("Localizable", "onboarding.secondPage.title", fallback: "Rules")
    }
    internal enum ThirdPage {
      /// for the first three letters there is one point each
      internal static let body1 = L10n.tr("Localizable", "onboarding.thirdPage.body1", fallback: "for the first three letters there is one point each")
      /// for every following letter two points, then four, six and so on
      internal static let body2 = L10n.tr("Localizable", "onboarding.thirdPage.body2", fallback: "for every following letter two points, then four, six and so on")
      /// Let's go!
      internal static let buttonTitle = L10n.tr("Localizable", "onboarding.thirdPage.buttonTitle", fallback: "Let's go!")
      /// Scoring
      internal static let title = L10n.tr("Localizable", "onboarding.thirdPage.title", fallback: "Scoring")
    }
  }
  internal enum ResetGameAlert {
    /// When you reset the game, all words and your score will be reset and lost.
    internal static let message = L10n.tr("Localizable", "resetGameAlert.message", fallback: "When you reset the game, all words and your score will be reset and lost.")
    /// Are you sure?
    internal static let title = L10n.tr("Localizable", "resetGameAlert.title", fallback: "Are you sure?")
  }
  internal enum SharedWord {
    internal enum Alert {
      internal enum NoValidStartword {
        /// This is not a valid start word!
        internal static let message = L10n.tr("Localizable", "sharedWord.alert.noValidStartword.message", fallback: "This is not a valid start word!")
        /// Error!
        internal static let title = L10n.tr("Localizable", "sharedWord.alert.noValidStartword.title", fallback: "Error!")
      }
      internal enum UsedWordsInCurrentSession {
        /// You're already playing a game. Are you sure you want to reset it and start a new one with the shared word? The current progression will be lost!
        internal static let message = L10n.tr("Localizable", "sharedWord.alert.usedWordsInCurrentSession.message", fallback: "You're already playing a game. Are you sure you want to reset it and start a new one with the shared word? The current progression will be lost!")
        /// Warning!
        internal static let title = L10n.tr("Localizable", "sharedWord.alert.usedWordsInCurrentSession.title", fallback: "Warning!")
      }
    }
  }
  internal enum Widget {
    /// No words found yet. What are you waiting for?
    internal static let noWords = L10n.tr("Localizable", "widget.noWords", fallback: "No words found yet. What are you waiting for?")
    /// Found %@ of %@ possible words.
    internal static func wordsFound(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "widget.wordsFound", String(describing: p1), String(describing: p2), fallback: "Found %@ of %@ possible words.")
    }
  }
  internal enum WordError {
    internal enum NotOriginal {
      /// Come on, be more original!
      internal static let message = L10n.tr("Localizable", "wordError.notOriginal.message", fallback: "Come on, be more original!")
      /// Word Already Used
      internal static let title = L10n.tr("Localizable", "wordError.notOriginal.title", fallback: "Word Already Used")
    }
    internal enum NotPossible {
      /// You can't spell that from "%@". Please look again.
      internal static func message(_ p1: Any) -> String {
        return L10n.tr("Localizable", "wordError.notPossible.message", String(describing: p1), fallback: "You can't spell that from \"%@\". Please look again.")
      }
      /// Word Not Possible
      internal static let title = L10n.tr("Localizable", "wordError.notPossible.title", fallback: "Word Not Possible")
    }
    internal enum NotReal {
      /// You can't just make them up, you know?
      internal static let message = L10n.tr("Localizable", "wordError.notReal.message", fallback: "You can't just make them up, you know?")
      /// Word Not Recognized
      internal static let title = L10n.tr("Localizable", "wordError.notReal.title", fallback: "Word Not Recognized")
    }
    internal enum TooShort {
      /// The word should have at least three characters.
      internal static let message = L10n.tr("Localizable", "wordError.tooShort.message", fallback: "The word should have at least three characters.")
      /// Too Short
      internal static let title = L10n.tr("Localizable", "wordError.tooShort.title", fallback: "Too Short")
    }
  }
  internal enum Words {
    /// Plural format key: "%#@words@"
    internal static func count(_ p1: Int) -> String {
      return L10n.tr("Localizable", "words.count", p1, fallback: "Plural format key: \"%#@words@\"")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
