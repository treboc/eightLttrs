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
  /// Plural format key: "%#@wordsCount@ %#@score@"
  internal static func endSessionBody(_ p1: Int, _ p2: Int) -> String {
    return L10n.tr("Localizable", "endSessionBody", p1, p2, fallback: "Plural format key: \"%#@wordsCount@ %#@score@\"")
  }
  /// English
  internal static let english = L10n.tr("Localizable", "english", fallback: "English")
  /// Localizable.strings
  ///  eightLttrs
  /// 
  ///  Created by Marvin Lee Kobert on 18.08.22.
  internal static let german = L10n.tr("Localizable", "german", fallback: "German")
  /// last added
  internal static let lastAdded = L10n.tr("Localizable", "lastAdded", fallback: "last added")
  /// possible words
  internal static let possibleWords = L10n.tr("Localizable", "possibleWords", fallback: "possible words")
  /// Score
  internal static let score = L10n.tr("Localizable", "score", fallback: "Score")
  /// Plural format key: "%#@wordsCount@ %#@score@"
  internal static func shareSessionMessage(_ p1: Int, _ p2: Int) -> String {
    return L10n.tr("Localizable", "shareSessionMessage", p1, p2, fallback: "Plural format key: \"%#@wordsCount@ %#@score@\"")
  }
  internal enum A11y {
    internal enum HighscoreListRowView {
      /// %@, %@, %@ Points
      internal static func label(_ p1: Any, _ p2: Any, _ p3: Any) -> String {
        return L10n.tr("Localizable", "a11y.highscoreListRowView.label", String(describing: p1), String(describing: p2), String(describing: p3), fallback: "%@, %@, %@ Points")
      }
    }
    internal enum MainView {
      /// %@, base word
      internal static func title(_ p1: Any) -> String {
        return L10n.tr("Localizable", "a11y.mainView.title", String(describing: p1), fallback: "%@, base word")
      }
      internal enum Cell {
        /// %@, %@ points
        internal static func label(_ p1: Any, _ p2: Any) -> String {
          return L10n.tr("Localizable", "a11y.mainView.cell.label", String(describing: p1), String(describing: p2), fallback: "%@, %@ points")
        }
      }
      internal enum ScoreLabels {
        /// %@ of %@ possible points
        internal static func label(_ p1: Any, _ p2: Any) -> String {
          return L10n.tr("Localizable", "a11y.mainView.scoreLabels.label", String(describing: p1), String(describing: p2), fallback: "%@ of %@ possible points")
        }
      }
      internal enum Textfield {
        /// Put your guessed word here.
        internal static let hint = L10n.tr("Localizable", "a11y.mainView.textfield.hint", fallback: "Put your guessed word here.")
        /// Textfield
        internal static let label = L10n.tr("Localizable", "a11y.mainView.textfield.label", fallback: "Textfield")
      }
      internal enum WordsLabels {
        /// found %@ of %@ words
        internal static func label(_ p1: Any, _ p2: Any) -> String {
          return L10n.tr("Localizable", "a11y.mainView.wordsLabels.label", String(describing: p1), String(describing: p2), fallback: "found %@ of %@ words")
        }
      }
    }
    internal enum SessionDetailView {
      /// %@ of %@ Points
      internal static func score(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "a11y.sessionDetailView.score", String(describing: p1), String(describing: p2), fallback: "%@ of %@ Points")
      }
    }
  }
  internal enum ButtonTitle {
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "buttonTitle.cancel", fallback: "Cancel")
    /// Close
    internal static let close = L10n.tr("Localizable", "buttonTitle.close", fallback: "Close")
    /// Continue
    internal static let `continue` = L10n.tr("Localizable", "buttonTitle.continue", fallback: "Continue")
    /// Yes, I'm sure
    internal static let imSure = L10n.tr("Localizable", "buttonTitle.imSure", fallback: "Yes, I'm sure")
    /// Next
    internal static let next = L10n.tr("Localizable", "buttonTitle.next", fallback: "Next")
    /// OK
    internal static let ok = L10n.tr("Localizable", "buttonTitle.ok", fallback: "OK")
    /// Save
    internal static let save = L10n.tr("Localizable", "buttonTitle.save", fallback: "Save")
    /// Share Session
    internal static let shareSession = L10n.tr("Localizable", "buttonTitle.shareSession", fallback: "Share Session")
    /// Skip
    internal static let skip = L10n.tr("Localizable", "buttonTitle.skip", fallback: "Skip")
    /// Submit
    internal static let submit = L10n.tr("Localizable", "buttonTitle.submit", fallback: "Submit")
  }
  internal enum CoinShopInfoPage {
    /// Plural format key: "%#@to100percent@"
    internal static func to100percent(_ p1: Int) -> String {
      return L10n.tr("Localizable", "coinShopInfoPage.to100percent", p1, fallback: "Plural format key: \"%#@to100percent@\"")
    }
    /// Plural format key: "%#@to50percent@"
    internal static func to50percent(_ p1: Int) -> String {
      return L10n.tr("Localizable", "coinShopInfoPage.to50percent", p1, fallback: "Plural format key: \"%#@to50percent@\"")
    }
    /// Plural format key: "%#@wordsLeft@"
    internal static func wordsLeft(_ p1: Int) -> String {
      return L10n.tr("Localizable", "coinShopInfoPage.wordsLeft", p1, fallback: "Plural format key: \"%#@wordsLeft@\"")
    }
  }
  internal enum CoinShopView {
    internal enum BuyPage {
      /// Buy
      internal static let buyButtonTitle = L10n.tr("Localizable", "coinShopView.buyPage.buyButtonTitle", fallback: "Buy")
      /// Five Words
      internal static let fiveWords = L10n.tr("Localizable", "coinShopView.buyPage.fiveWords", fallback: "Five Words")
      /// How many words do you want to buy?
      internal static let heading = L10n.tr("Localizable", "coinShopView.buyPage.heading", fallback: "How many words do you want to buy?")
      /// Info
      internal static let infoPageSelectionButtonTitle = L10n.tr("Localizable", "coinShopView.buyPage.infoPageSelectionButtonTitle", fallback: "Info")
      /// One Word
      internal static let oneWord = L10n.tr("Localizable", "coinShopView.buyPage.oneWord", fallback: "One Word")
      /// Price: %@P
      internal static func price(_ p1: Any) -> String {
        return L10n.tr("Localizable", "coinShopView.buyPage.price %@", String(describing: p1), fallback: "Price: %@P")
      }
      /// Price: ~%@P~ %@P
      internal static func strikethroughPrice(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "coinShopView.buyPage.strikethroughPrice %@ %@", String(describing: p1), String(describing: p2), fallback: "Price: ~%@P~ %@P")
      }
      /// Three Words
      internal static let threeWords = L10n.tr("Localizable", "coinShopView.buyPage.threeWords", fallback: "Three Words")
      internal enum BuyAction {
        /// Error buying words:
        /// %@
        internal static func error(_ p1: Any) -> String {
          return L10n.tr("Localizable", "coinShopView.buyPage.buyAction.error %@", String(describing: p1), fallback: "Error buying words:\n%@")
        }
        /// Purchase completed
        internal static let successful = L10n.tr("Localizable", "coinShopView.buyPage.buyAction.successful", fallback: "Purchase completed")
      }
    }
    internal enum InfoPage {
      /// For completing a word
      internal static let _100percentReached = L10n.tr("Localizable", "coinShopView.infoPage.100percentReached", fallback: "For completing a word")
      /// For 20 correct entered words
      internal static let _20correctWords = L10n.tr("Localizable", "coinShopView.infoPage.20correctWords", fallback: "For 20 correct entered words")
      /// When reaching 50%% of a word
      internal static let _50percentReached = L10n.tr("Localizable", "coinShopView.infoPage.50percentReached", fallback: "When reaching 50%% of a word")
      /// How to get points?
      internal static let heading = L10n.tr("Localizable", "coinShopView.infoPage.heading", fallback: "How to get points?")
      /// Shop
      internal static let shopPageSelectionButtonTitle = L10n.tr("Localizable", "coinShopView.infoPage.shopPageSelectionButtonTitle", fallback: "Shop")
      internal enum StatusBar {
        /// 100% reached!
        internal static let _100percentReached = L10n.tr("Localizable", "coinShopView.infoPage.statusBar.100percentReached", fallback: "100% reached!")
        /// 50% reached!
        internal static let _50percentReached = L10n.tr("Localizable", "coinShopView.infoPage.statusBar.50percentReached", fallback: "50% reached!")
      }
    }
  }
  internal enum ColorPicker {
    /// Dark
    internal static let dark = L10n.tr("Localizable", "colorPicker.dark", fallback: "Dark")
    /// Light
    internal static let light = L10n.tr("Localizable", "colorPicker.light", fallback: "Light")
    /// System
    internal static let system = L10n.tr("Localizable", "colorPicker.system", fallback: "System")
    /// Color Scheme
    internal static let title = L10n.tr("Localizable", "colorPicker.title", fallback: "Color Scheme")
  }
  internal enum EndGameAlert {
    /// Are you sure, you don't know any other words?
    internal static let message = L10n.tr("Localizable", "endGameAlert.message", fallback: "Are you sure, you don't know any other words?")
    /// Saving
    internal static let title = L10n.tr("Localizable", "endGameAlert.title", fallback: "Saving")
  }
  internal enum EndSessionView {
    /// Congratulations! 🎉
    internal static let title = L10n.tr("Localizable", "endSessionView.title", fallback: "Congratulations! 🎉")
  }
  internal enum HighscoreDetaiLView {
    /// Baseword
    internal static let baseword = L10n.tr("Localizable", "highscoreDetaiLView.baseword", fallback: "Baseword")
    /// Found %@
    internal static func foundWordsPercentage(_ p1: Any) -> String {
      return L10n.tr("Localizable", "highscoreDetaiLView.foundWordsPercentage", String(describing: p1), fallback: "Found %@")
    }
    /// Name
    internal static let name = L10n.tr("Localizable", "highscoreDetaiLView.name", fallback: "Name")
    /// Score
    internal static let score = L10n.tr("Localizable", "highscoreDetaiLView.score", fallback: "Score")
  }
  internal enum HighscoreDetailView {
    /// Words / poss. Score
    internal static let statistics = L10n.tr("Localizable", "highscoreDetailView.statistics", fallback: "Words / poss. Score")
    /// Details
    internal static let title = L10n.tr("Localizable", "highscoreDetailView.title", fallback: "Details")
    /// Try again
    internal static let tryAgain = L10n.tr("Localizable", "highscoreDetailView.tryAgain", fallback: "Try again")
  }
  internal enum HighscoreListEmptyListPlaceholder {
    /// Find some words, save your session and come back again later.
    internal static let body = L10n.tr("Localizable", "highscoreListEmptyListPlaceholder.body", fallback: "Find some words, save your session and come back again later.")
    /// It's empty here
    internal static let title = L10n.tr("Localizable", "highscoreListEmptyListPlaceholder.title", fallback: "It's empty here")
  }
  internal enum HighscoreListRowView {
    /// baseword war: *%@*
    internal static func basewordWas(_ p1: Any) -> String {
      return L10n.tr("Localizable", "highscoreListRowView.basewordWas", String(describing: p1), fallback: "baseword war: *%@*")
    }
  }
  internal enum HighscoreListView {
    /// Highscores
    internal static let title = L10n.tr("Localizable", "highscoreListView.title", fallback: "Highscores")
  }
  internal enum LegalNoticeView {
    /// Legal Notice
    internal static let title = L10n.tr("Localizable", "legalNoticeView.title", fallback: "Legal Notice")
  }
  internal enum MainView {
    /// Current Score
    internal static let currentScore = L10n.tr("Localizable", "mainView.currentScore", fallback: "Current Score")
    /// Words found
    internal static let foundWords = L10n.tr("Localizable", "mainView.foundWords", fallback: "Words found")
    internal enum ShopButton {
      /// Shop
      internal static let title = L10n.tr("Localizable", "mainView.shopButton.title", fallback: "Shop")
    }
  }
  internal enum MenuView {
    /// Baseword
    internal static let baseword = L10n.tr("Localizable", "menuView.baseword", fallback: "Baseword")
    /// End Session
    internal static let endSession = L10n.tr("Localizable", "menuView.endSession", fallback: "End Session")
    /// Filter Words
    internal static let filter = L10n.tr("Localizable", "menuView.filter", fallback: "Filter Words")
    /// When enabled, the list of already used words gets dynamically filtered.
    internal static let filterDescription = L10n.tr("Localizable", "menuView.filterDescription", fallback: "When enabled, the list of already used words gets dynamically filtered.")
    /// Haptic Feedback
    internal static let hapticFeedback = L10n.tr("Localizable", "menuView.hapticFeedback", fallback: "Haptic Feedback")
    /// New Baseword
    internal static let restartSession = L10n.tr("Localizable", "menuView.restartSession", fallback: "New Baseword")
    /// Settings
    internal static let settings = L10n.tr("Localizable", "menuView.settings", fallback: "Settings")
    /// Highscore
    internal static let showHighscore = L10n.tr("Localizable", "menuView.showHighscore", fallback: "Highscore")
    /// Sound
    internal static let sound = L10n.tr("Localizable", "menuView.sound", fallback: "Sound")
    /// Menu
    internal static let title = L10n.tr("Localizable", "menuView.title", fallback: "Menu")
    internal enum ChangedLanguage {
      /// You're now playing with different basewords.
      /// 
      /// This change will take effect on the next session.
      internal static let message = L10n.tr("Localizable", "menuView.changedLanguage.message", fallback: "You're now playing with different basewords.\n\nThis change will take effect on the next session.")
      /// Changed Language
      internal static let title = L10n.tr("Localizable", "menuView.changedLanguage.title", fallback: "Changed Language")
    }
    internal enum SupportEmail {
      /// Contact Support
      internal static let buttonHeader = L10n.tr("Localizable", "menuView.supportEmail.buttonHeader", fallback: "Contact Support")
      /// e.g. for requesting a missing word
      internal static let buttonSubtitle = L10n.tr("Localizable", "menuView.supportEmail.buttonSubtitle", fallback: "e.g. for requesting a missing word")
    }
  }
  internal enum Onboarding {
    internal enum FirstPage {
      /// you get a starting word. It has eight letters. You just make as many other words out of it as you can.
      internal static let body1 = L10n.tr("Localizable", "onboarding.firstPage.body1", fallback: "you get a starting word. It has eight letters. You just make as many other words out of it as you can.")
      /// take your time - the only important thing here is to find as many words as you can, no matter how long it takes.
      internal static let body2 = L10n.tr("Localizable", "onboarding.firstPage.body2", fallback: "take your time - the only important thing here is to find as many words as you can, no matter how long it takes.")
      /// What's the game about?
      internal static let title = L10n.tr("Localizable", "onboarding.firstPage.title", fallback: "What's the game about?")
    }
    internal enum SecondPage {
      /// all starting words are eight letters long
      internal static let body1 = L10n.tr("Localizable", "onboarding.secondPage.body1", fallback: "all starting words are eight letters long")
      /// your word must contain at least a minimum of three letters
      internal static let body2 = L10n.tr("Localizable", "onboarding.secondPage.body2", fallback: "your word must contain at least a minimum of three letters")
      /// possible words are nouns, adjectives and verbs in all their forms. In addition, names, abbreviations, numerals and much more.
      internal static let body3 = L10n.tr("Localizable", "onboarding.secondPage.body3", fallback: "possible words are nouns, adjectives and verbs in all their forms. In addition, names, abbreviations, numerals and much more.")
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
    /// When you reset the game, all words and your score will be reset and not saved.
    internal static let message = L10n.tr("Localizable", "resetGameAlert.message", fallback: "When you reset the game, all words and your score will be reset and not saved.")
    /// Are you sure?
    internal static let title = L10n.tr("Localizable", "resetGameAlert.title", fallback: "Are you sure?")
  }
  internal enum SessionDetailChartView {
    /// avg. %@ pts. per word
    internal static func subtitle(_ p1: Any) -> String {
      return L10n.tr("Localizable", "sessionDetailChartView.subtitle", String(describing: p1), fallback: "avg. %@ pts. per word")
    }
    /// Words Per Points
    internal static let title = L10n.tr("Localizable", "sessionDetailChartView.title", fallback: "Words Per Points")
  }
  internal enum ShareLink {
    /// I'd like to know if you can do better. My baseword was %@.
    /// 
    internal static func message(_ p1: Any) -> String {
      return L10n.tr("Localizable", "shareLink.message", String(describing: p1), fallback: "I'd like to know if you can do better. My baseword was %@.\n")
    }
    /// "%@" will be shared.
    /// Who should try it?
    internal static func previewMessage(_ p1: Any) -> String {
      return L10n.tr("Localizable", "shareLink.previewMessage", String(describing: p1), fallback: "\"%@\" will be shared.\nWho should try it?")
    }
    /// Try it yourself!
    internal static let subject = L10n.tr("Localizable", "shareLink.subject", fallback: "Try it yourself!")
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
    internal enum TryUppercaseHint {
      /// Try it again! Notice that it depends on whether you capitalize the words or not.
      internal static let message = L10n.tr("Localizable", "wordError.tryUppercaseHint.message", fallback: "Try it again! Notice that it depends on whether you capitalize the words or not.")
      /// Hint
      internal static let title = L10n.tr("Localizable", "wordError.tryUppercaseHint.title", fallback: "Hint")
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
