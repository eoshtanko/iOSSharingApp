//
//  InitialTabBarViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 11.03.2022.
//

import UIKit

class RootTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let chatViewController = UINavigationController(
            rootViewController: ConversationsListViewController())
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileViewController = UINavigationController(
            rootViewController: storyboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController)
        
        let exchangesViewController = UINavigationController(
            rootViewController: ExchangesViewController())
        
        let searchViewController = UINavigationController(
            rootViewController: SearchViewController())
        
        self.setViewControllers([searchViewController, exchangesViewController, chatViewController, profileViewController], animated: false)
        
        setImages()
        self.selectedIndex = 3
    }

    private func setImages() {
        self.tabBar.items?[0].image = UIImage(systemName: "magnifyingglass")
        self.tabBar.items?[1].image = UIImage(systemName: "archivebox")
        self.tabBar.items?[2].image = UIImage(systemName: "message")
        self.tabBar.items?[3].image = UIImage(systemName: "person")
    }
}
