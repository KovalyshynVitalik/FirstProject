//
//  PageViewController.swift
//  ConcertApp
//
//  Created by Vitalik on 8/26/19.
//  Copyright © 2019 Misha. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
    var event: Event?
    var pageController: UIPageViewController?
    var controllers = [UIViewController]()
    public var images: [String]?
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController) {
            if index > 0 {
                return controllers [index - 1]
            } else {
                return nil
            }
        }
        return nil
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController) {
            if index < controllers.count - 1 {
                return controllers [index + 1]
            } else {
                return nil
            }
        }
        return nil
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        
        //MARK: populate UI with controllers
        populateWithControllers()
        
        
        if !controllers.isEmpty {
            var array = [UIViewController]()
            array.append(controllers.first!)
            
            
            self.setViewControllers(array, direction: .forward, animated: true, completion: nil)
            
        }
        
        //        self.setViewControllers([controllers[3]], direction: .forward, animated: true )
        //         self.setViewControllers([controllers[0]], direction: .forward, animated: true)
        
        
        
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController?.dataSource = self
        pageController?.delegate = self
        addChild(pageController!)
        view.addSubview(pageController!.view)
        view.frame = CGRect(x: 0, y: 200, width: 400, height: 400)
    }
    
    
    
    func populateWithControllers() {
        
        guard let images = self.images else { return }
        
        for imageName in images {
            let itemViewController = storyboard?.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController
            itemViewController.imageName = imageName
            controllers.append(itemViewController)
        }
        
        print()
    }
    
    
}
