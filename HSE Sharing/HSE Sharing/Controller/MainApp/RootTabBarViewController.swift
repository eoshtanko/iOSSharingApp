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
        
        let storyboardProfile = UIStoryboard(name: "Profile", bundle: nil)
        let profileViewController = UINavigationController(
            rootViewController: storyboardProfile.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController)
        
        let storyboardCurrentExchanges = UIStoryboard(name: "CurrentExchanges", bundle: nil)
        let exchangesViewController = UINavigationController(
            rootViewController: storyboardCurrentExchanges.instantiateViewController(withIdentifier: "CurrentExchanges") as! ExchangesViewController)
        
        let searchViewController = UINavigationController(
            rootViewController: SearchViewController())
        
        self.setViewControllers([searchViewController, exchangesViewController, chatViewController, profileViewController], animated: false)
        
        setImages()
        self.selectedIndex = 3
    }
    
    deinit {
        Api.shared.stopMessaging()
    }

    private func setImages() {
        self.tabBar.items?[0].image = UIImage(systemName: "magnifyingglass")
        self.tabBar.items?[1].image = UIImage(systemName: "archivebox")
        self.tabBar.items?[2].image = UIImage(systemName: "message")
        self.tabBar.items?[3].image = UIImage(systemName: "person")
    }
}
