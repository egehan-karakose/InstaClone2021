//
//  SearchUserController.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 22.01.2021.
//

import UIKit
import Firebase

class SearchUserController : UICollectionViewController, UISearchBarDelegate {
    

    lazy var searchBar : UISearchBar = {
        let searchbar = UISearchBar()
        
        searchbar.placeholder = "Enter User Name... "
        
        //        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor =
        
        searchbar.delegate = self
        
        return searchbar
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = users
        }else {
            self.filteredUsers = self.users.filter({ (user) -> Bool in
                return user.userName.contains(searchText)
            })
        }
       
        
        self.collectionView.reloadData()
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.backgroundColor = .systemBackground
                
        navigationController?.navigationBar.addSubview(searchBar)
        
        let navBar = navigationController?.navigationBar
        
        searchBar.anchor(top: navBar?.topAnchor, bottom: navBar?.bottomAnchor, leading: navBar?.leadingAnchor, trailing: navBar?.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: -10, width: 0, height: 0)
        
        
        collectionView.register(SearchUserCell.self, forCellWithReuseIdentifier: SearchUserCell.identifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag // dismiss keyboard on drag list items
        
        
        getUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.isHidden = false
    }
    
    
    
    var filteredUsers = [User]()
    var users = [User]()
    
    fileprivate func getUsers(){
        Firestore.firestore().collection("Users").getDocuments { (snap, error) in
            if let error = error {
                print("Failed to get users \(error.localizedDescription)" )
            }
            snap?.documentChanges.forEach({ (change) in
                if change.type == .added {
                    let user = User(userData: change.document.data())
                    
                    if user.userId != Auth.auth().currentUser?.uid {
                        self.users.append(user)
                    }
                    
                }
            })
            self.users.sort { (u1, u2) -> Bool in
                return u1.userName.compare(u2.userName) == .orderedAscending
            }
            self.filteredUsers = self.users
            self.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  SearchUserCell.identifier, for: indexPath) as! SearchUserCell
        
        cell.user = filteredUsers[indexPath.row]
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        let user = filteredUsers[indexPath.row]
        let userProfileContoller = UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        userProfileContoller.userID = user.userId
        navigationController?.pushViewController(userProfileContoller, animated: true)
    }
    
}


extension SearchUserController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
}
