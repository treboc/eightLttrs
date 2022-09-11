//
//  OnboardingPageViewController.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 18.08.22.
//

import UIKit

class OnboardingPageViewController: UIViewController {
  let titleLabel = UILabel()
  let bodyLabel = UILabel()
  let startButton = UIButton()

  var isLastPage: Bool = false

  init(title: String, body: [String], isLastPage: Bool = false) {
    super.init(nibName: nil, bundle: nil)
    titleLabel.text = title
    bodyLabel.attributedText = add(stringList: body, font: .preferredFont(forTextStyle: .body))
    self.isLastPage = isLastPage
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    style()
    layout()
  }
}

extension OnboardingPageViewController {
  private func style() {
    var roundedTitleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
    roundedTitleFont = UIFont(descriptor:
                                roundedTitleFont.fontDescriptor
      .withDesign(.rounded)?
      .withSymbolicTraits(.traitBold)
                              ??
                              roundedTitleFont.fontDescriptor,
                              size: roundedTitleFont.pointSize
    )
    let titleLabelFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: roundedTitleFont)

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = titleLabelFont
    titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    titleLabel.numberOfLines = 0

    bodyLabel.translatesAutoresizingMaskIntoConstraints = false
    bodyLabel.textColor = .secondaryLabel
    bodyLabel.numberOfLines = 0
    bodyLabel.setContentHuggingPriority(.defaultLow, for: .vertical)

    if isLastPage {
      startButton.translatesAutoresizingMaskIntoConstraints = false
      startButton.setTitle(L10n.Onboarding.ThirdPage.buttonTitle, for: .normal)
      startButton.configuration = .borderedProminent()
      startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
  }

  private func layout() {
    view.addSubview(titleLabel)
    view.addSubview(bodyLabel)

    if isLastPage {
      view.addSubview(startButton)

      NSLayoutConstraint.activate([
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 128),

        bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
        bodyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
        bodyLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),

        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        startButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
        startButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 16),
        startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64),
        startButton.heightAnchor.constraint(equalToConstant: 40),
      ])
    } else {
      NSLayoutConstraint.activate([
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 128),

        bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
        bodyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
        bodyLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -128)
      ])
    }
  }

  @objc
  private func startButtonTapped(_ sender: UIButton) {
    dismiss(animated: true)
    // set isStarted, so that the onboarding does not show again on next start
    UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isFirstStart)
  }
}

extension OnboardingPageViewController {
  // Transform String into bullet-points styled paragraph
  func add(stringList: [String],
           font: UIFont,
           bullet: String = "\u{2022}",
           indentation: CGFloat = 20,
           lineSpacing: CGFloat = 2,
           paragraphSpacing: CGFloat = 12,
           textColor: UIColor = .gray,
           bulletColor: UIColor = .red) -> NSAttributedString {

    let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
    let bulletAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: bulletColor]

    let paragraphStyle = NSMutableParagraphStyle()
    let nonOptions = [NSTextTab.OptionKey: Any]()
    paragraphStyle.tabStops = [
      NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
    paragraphStyle.defaultTabInterval = indentation
    paragraphStyle.lineSpacing = lineSpacing
    paragraphStyle.paragraphSpacing = paragraphSpacing
    paragraphStyle.headIndent = indentation

    let bulletList = NSMutableAttributedString()
    for string in stringList {
      let formattedString = "\(bullet)\t\(string)\n"
      let attributedString = NSMutableAttributedString(string: formattedString)

      attributedString.addAttributes(
        [NSAttributedString.Key.paragraphStyle : paragraphStyle],
        range: NSMakeRange(0, attributedString.length))

      attributedString.addAttributes(
        textAttributes,
        range: NSMakeRange(0, attributedString.length))

      let string:NSString = NSString(string: formattedString)
      let rangeForBullet:NSRange = string.range(of: bullet)
      attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
      bulletList.append(attributedString)
    }

    return bulletList
  }
}
