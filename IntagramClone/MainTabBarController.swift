//
//  MainTabBarController.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 9.01.2021.
//

import Foundation
import UIKit

class MainTabBarController : UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        let layout = UICollectionViewFlowLayout()
        let userProfileViewContoller = UserProfileViewController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: userProfileViewContoller)
        navController.tabBarItem.image = #imageLiteral(resourceName: "Profil")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "Profil_Secili")
        tabBar.tintColor = .label
        viewControllers = [UIViewController(),navController]
        
       
    }
}
