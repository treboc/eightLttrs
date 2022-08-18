// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Onboarding {
    internal enum FirstPage {
      /// based on a project of 100daysOfSwift by Paul Hudson
      internal static let body1 = L10n.tr("Localizable", "onboarding.firstPage.body1", fallback: #"based on a project of 100daysOfSwift by Paul Hudson"#)
      /// try to find as many words as possible out of a random starting word
      internal static let body2 = L10n.tr("Localizable", "onboarding.firstPage.body2", fallback: #"try to find as many words as possible out of a random starting word"#)
      /// What's the game about?
      internal static let title = L10n.tr("Localizable", "onboarding.firstPage.title", fallback: #"What's the game about?"#)
    }
    internal enum NextButton {
      /// Next
      internal static let title = L10n.tr("Localizable", "onboarding.nextButton.title", fallback: #"Next"#)
    }
    internal enum SecondPage {
      /// all starting words are eight letters long
      internal static let body1 = L10n.tr("Localizable", "onboarding.secondPage.body1", fallback: #"all starting words are eight letters long"#)
      /// your word must contain at least a minimum of three letters
      internal static let body2 = L10n.tr("Localizable", "onboarding.secondPage.body2", fallback: #"your word must contain at least a minimum of three letters"#)
      /// Rules
      internal static let title = L10n.tr("Localizable", "onboarding.secondPage.title", fallback: #"Rules"#)
    }
    internal enum SkipButton {
      /// Skip
      internal static let title = L10n.tr("Localizable", "onboarding.skipButton.title", fallback: #"Skip"#)
    }
    internal enum ThirdPage {
      /// for the first three letters there is one point each
      internal static let body1 = L10n.tr("Localizable", "onboarding.thirdPage.body1", fallback: #"for the first three letters there is one point each"#)
      /// for every following letter two points, then four, six and so on
      internal static let body2 = L10n.tr("Localizable", "onboarding.thirdPage.body2", fallback: #"for every following letter two points, then four, six and so on"#)
      /// Let's go!
      internal static let buttonTitle = L10n.tr("Localizable", "onboarding.thirdPage.buttonTitle", fallback: #"Let's go!"#)
      /// Scoring
      internal static let title = L10n.tr("Localizable", "onboarding.thirdPage.title", fallback: #"Scoring"#)
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
