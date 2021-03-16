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
        
        self.delegate = self
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
        
        
        let mainNavController = createNavController(image: #imageLiteral(resourceName: "Ana_Ekran_Secili_Degil"), selectedImage: #imageLiteral(resourceName: "Ana_Ekran_Secili"), rootViewController: MainPageViewController(collectionViewLayout: UICollectionViewFlowLayout()))

        let searchNavController = createNavController(image:#imageLiteral(resourceName: "Ara_Secili_Degil"), selectedImage: #imageLiteral(resourceName: "Ara_Secili"), rootViewController: SearchUserController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let addNavController = createNavController(image: #imageLiteral(resourceName: "Ekle_Secili_Degil"), selectedImage: #imageLiteral(resourceName: "Ekle_Secili_Degil"))
        let likeNavController = createNavController(image: #imageLiteral(resourceName: "Begeni_Secili_Degil"), selectedImage: #imageLiteral(resourceName: "Begeni_Secili"))
        
        let layout = UICollectionViewFlowLayout()
        let userProfileViewContoller = UserProfileViewController(collectionViewLayout: layout)
        let profileNavController = UINavigationController(rootViewController: userProfileViewContoller)
        profileNavController.tabBarItem.image = #imageLiteral(resourceName: "Profil")
        profileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "Profil_Secili")
        tabBar.tintColor = .label
        viewControllers = [mainNavController,searchNavController,addNavController,likeNavController, profileNavController]
        
        guard let items = tabBar.items else {return}
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -4, right: 0)
        }
        
    }
    
    
    fileprivate func createNavController(image: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let rootController = rootViewController
        let navContoller = UINavigationController(rootViewController: rootController)
        navContoller.tabBarItem.image = image
        navContoller.tabBarItem.selectedImage = selectedImage
        return navContoller
    }
}


extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let index = viewControllers?.firstIndex(of: viewController) else { return true}
        
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoPickerController = PhotoPickerController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoPickerController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
            
           return false
        }
        
        return true
    }
}
