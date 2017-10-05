//
//  DukePersonPageViewController.swift
//  ECE564_F17_HOMEWORK
//
//  Created by Robert Steilberg on 9/25/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import UIKit

class DukePersonPageViewController: UIPageViewController {
    
    var pages : [UIViewController] = [UIViewController]()
    
    var dukePerson: DukePerson?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        self.navigationController?.navigationBar.isTranslucent = false;

        let detailPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DukePersonTableView") as! DukePersonTableViewController
        // pass through DukePerson data
        detailPage.dukePerson = dukePerson
        pages.append(detailPage)

        self.navigationItem.leftBarButtonItem = detailPage.leftBarButton
        self.navigationItem.rightBarButtonItem = detailPage.rightBarButton
        self.navigationItem.title = dukePerson?.getFullName()
        setViewControllers([detailPage], direction: .forward, animated: true, completion: nil)
        
        // check if DukePerson instance has an animation
        if let animation = dukePerson?.getAnimationController() {
            pages.append(animation)
        }
    }
}

// MARK: UIPageViewControllerDataSource

extension DukePersonPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard pages.count > previousIndex else {
            return nil
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = pages.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return pages[nextIndex]
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.gray
        appearance.currentPageIndicatorTintColor = UIColor.white
        appearance.backgroundColor = UIColor.darkGray
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        setupPageControl()
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
