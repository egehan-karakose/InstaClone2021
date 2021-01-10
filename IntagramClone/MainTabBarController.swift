//
//  MainTabBarController.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 9.01.2021.
//

import Foundation
import UIKit
import Firebase


class MainTabBarController : UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        if Auth.auth().currentUser == nil {
            // not logged in
            
            DispatchQueue.main.async {
                let loginVC = LoginViewController()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        
       
        presentVC()
        
        
    }
    
    func presentVC(){
        let layout = UICollectionViewFlowLayout()
        let userProfileViewContoller = UserProfileViewController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: userProfileViewContoller)
        navController.tabBarItem.image = #imageLiteral(resourceName: "Profil")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "Profil_Secili")
        tabBar.tintColor = .label
        viewControllers = [navController,UIViewController()]
        
    }
}
