//
//  PageViewController.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/27/24.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var pages: [UIViewController] = [UIViewController]()
    
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
           super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
       }
    
    required init?(coder: NSCoder) {
            super.init(coder: coder)
        }


    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = nil
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pm = storyboard.instantiateViewController(withIdentifier: "AQIViewControllerID") as! AQISubviewController
        let voc = storyboard.instantiateViewController(withIdentifier: "UVViewControllerID") as! UVSubviewController
        pages.append(pm)
        pages.append(voc)
        
        setViewControllers([pages[0]], direction: .forward, animated: true)
    }
}

extension PageViewController:  UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }

               let previousIndex = viewControllerIndex - 1

               guard previousIndex >= 0 else { return pages.last }

               guard pages.count > previousIndex else { return nil }

               return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }

                let nextIndex = viewControllerIndex + 1

                guard nextIndex < pages.count else { return pages.first }

                guard pages.count > nextIndex else { return nil }

                return pages[nextIndex]
    }
    
}

extension PageViewController: UIPageViewControllerDelegate {

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {

        guard let firstVC = pageViewController.viewControllers?.first else {
            return 0
        }
        guard let firstVCIndex = pages.firstIndex(of: firstVC) else {
            return 0
        }

        return firstVCIndex
    }
}
