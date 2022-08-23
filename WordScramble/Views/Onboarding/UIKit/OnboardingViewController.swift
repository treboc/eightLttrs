//
//  OnboardingViewController.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 16.08.22.
//

import UIKit

class OnboardingViewController: UIPageViewController {
  var pages = [UIViewController]()

  // Controls
  let skipButton = UIButton()
  let nextButton = UIButton()
  let pageControl = UIPageControl()
  let initialPage = 0

  // Animations
  var pageControlBottomAnchor: NSLayoutConstraint?
  var skipButtonTopAnchor: NSLayoutConstraint?
  var nextButtonTopAnchor: NSLayoutConstraint?

  override func viewDidLoad() {
    super.viewDidLoad()

    setup()
    style()
    layout()
  }
}

extension OnboardingViewController {
  private func setup() {
    dataSource = self
    delegate = self
    view.backgroundColor = .systemBackground

    pageControl.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)

    let page1 = OnboardingPageViewController(
      title: L10n.Onboarding.FirstPage.title,
      body: [L10n.Onboarding.FirstPage.body1,
             L10n.Onboarding.FirstPage.body2])
    let page2 = OnboardingPageViewController(
      title: L10n.Onboarding.SecondPage.title,
      body: [L10n.Onboarding.SecondPage.body1,
             L10n.Onboarding.SecondPage.body2])
    let page3 = OnboardingPageViewController(
      title: L10n.Onboarding.ThirdPage.title,
      body: [L10n.Onboarding.ThirdPage.body1,
             L10n.Onboarding.ThirdPage.body2],
      isLastPage: true)

    pages.append(contentsOf: [page1, page2, page3])

    setViewControllers([pages[initialPage]], direction: .forward, animated: true)
  }

  private func style() {
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    pageControl.currentPageIndicatorTintColor = .tintColor
    pageControl.pageIndicatorTintColor = .secondaryLabel
    pageControl.numberOfPages = pages.count
    pageControl.currentPage = initialPage

    skipButton.translatesAutoresizingMaskIntoConstraints = false
    skipButton.setTitle(L10n.ButtonTitle.skip, for: .normal)
    skipButton.configuration = .plain()
    skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)

    nextButton.translatesAutoresizingMaskIntoConstraints = false
    nextButton.setTitle(L10n.ButtonTitle.next, for: .normal)
    nextButton.configuration = .plain()
    nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
  }

  private func layout() {
    view.addSubview(pageControl)
    view.addSubview(nextButton)
    view.addSubview(skipButton)

    NSLayoutConstraint.activate([
      pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
      pageControl.heightAnchor.constraint(equalToConstant: 20),
      pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      skipButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),

      view.trailingAnchor.constraint(equalToSystemSpacingAfter: nextButton.trailingAnchor, multiplier: 2)
    ])

    // for animations
    pageControlBottomAnchor = pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
    skipButtonTopAnchor = skipButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2)
    nextButtonTopAnchor = nextButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2)

    pageControlBottomAnchor?.isActive = true
    skipButtonTopAnchor?.isActive = true
    nextButtonTopAnchor?.isActive = true
  }
}

// MARK: - PageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

    if currentIndex > 0 {
      return pages[currentIndex - 1]
    } else {
      return nil
    }
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

    if currentIndex < pages.count - 1 {
      return pages[currentIndex + 1]
    } else {
      return nil
    }
  }
}

// MARK: - PageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
  // How we keep our pageControl in sync with viewControllers
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    guard
      let viewControllers = pageViewController.viewControllers,
      let currentIndex = pages.firstIndex(of: viewControllers[0])
    else { return }

    pageControl.currentPage = currentIndex
    animateControlsIfNeeded()
  }

  private func animateControlsIfNeeded() {
    let lastPage = pageControl.currentPage == pages.count - 1

    if lastPage {
      hideControls()
    } else {
      showControls()
    }

    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
      self.view.layoutIfNeeded()
    }, completion: nil)
  }

  private func hideControls() {
    pageControlBottomAnchor?.constant = 80
    skipButtonTopAnchor?.constant = -80
    nextButtonTopAnchor?.constant = -80
  }

  private func showControls() {
    pageControlBottomAnchor?.constant = -16
    skipButtonTopAnchor?.constant = 16
    nextButtonTopAnchor?.constant = 16
  }
}

// MARK: - Actions
extension OnboardingViewController {
  @objc
  func pageControlTapped(_ sender: UIPageControl) {
    setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true)
    animateControlsIfNeeded()
  }

  @objc
  func skipButtonTapped(_ sender: UIButton) {
    let lastPage = pages.count - 1
    pageControl.currentPage = lastPage

    goToSpecificPage(index: lastPage, ofViewControllers: pages)
    animateControlsIfNeeded()
  }

  @objc
  func nextButtonTapped(_ sender: UIButton) {
    if pageControl.currentPage < pages.count - 1 {
      pageControl.currentPage += 1
    }

    goToNextPage()
    animateControlsIfNeeded()
  }
}

// MARK: - Extensions
extension UIPageViewController {
  func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
    guard
      let currentPage = viewControllers?[0],
      let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage)
    else { return }

    setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
  }

  func goToPrevPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
    guard
      let currentPage = viewControllers?[0],
      let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentPage)
    else { return }

    setViewControllers([prevPage], direction: .forward, animated: animated, completion: completion)
  }

  func goToSpecificPage(index: Int, ofViewControllers pages: [UIViewController]) {
    setViewControllers([pages[index]], direction: .forward, animated: true)
  }
}
