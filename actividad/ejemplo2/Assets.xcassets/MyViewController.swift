//
//  MyViewController.swift
//  ejemplo2
//
//  Created by gdaalumno on 9/25/19.
//  Copyright © 2019 gdaalumno. All rights reserved.
//

import UIKit

class MyViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "tutorial")
        self.dataSource = self
        
        setViewControllers([pages.first!], direction: .forward, animated: true, completion: nil)
    }
    
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "Page 1"),
            self.getViewController(withIdentifier: "Page 2"),
            self.getViewController(withIdentifier: "Page 3")
        ]
    }()
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MyViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = currentIndex - 1
        
        guard previousIndex >= 0 else {
            return pages.last
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = (currentIndex + 1) % pages.count

        return pages[nextIndex]
    }
}
