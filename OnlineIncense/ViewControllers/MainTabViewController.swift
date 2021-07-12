//
//  MainTabViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/10.
//

import UIKit

class MainTabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTab()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    func setupTab() {
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(title: "",
                                            image: UIImage(named: "unselectedSearch")?.resize(),
                                            selectedImage: UIImage(named: "selectedSearch")?.resize()?.withRenderingMode(.alwaysOriginal))
        
        let createVC = CreateViewController()
        createVC.tabBarItem = UITabBarItem(title: "",
                                             image: UIImage(named: "unselectedCreate")?.resize(),
                                             selectedImage: UIImage(named: "selectedCreate")?.resize()?.withRenderingMode(.alwaysOriginal))
        
        let myPageVC = MyPageViewController()
        myPageVC.tabBarItem = UITabBarItem(title: "",
                                             image: UIImage(named: "unselectedMyPage")?.resize(),
                                             selectedImage: UIImage(named: "selectedMyPage")?.resize()?.withRenderingMode(.alwaysOriginal))
        
        viewControllers = [searchVC, createVC, myPageVC]
    }
    
}
