//
//  UserProfileViewController.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 9.01.2021.
//

import UIKit
import Firebase


class UserProfileViewController: UICollectionViewController {
    
    
    let postCellID = "postCellID"
    
    var currentUser : User?

    override func viewDidLoad() {
        super.viewDidLoad()

        getUser()
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UserProfileHeader.identifier)
        
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: postCellID)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 5) / 3
        
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellID, for: indexPath)
        
        postCell.backgroundColor = .link
        
        return postCell
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UserProfileHeader.identifier, for: indexPath) as! UserProfileHeader
        
        header.currentUser = currentUser
        
        return header
    }
    
    
    
    
    fileprivate func getUser(){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("Users").document(userId).getDocument { (snapshot, error) in
            if let error = error {
                print("Fail to get user data : ",error.localizedDescription)
            }
            
            guard let data = snapshot?.data() else {
                return
            }
            
            self.currentUser = User(userData: data)
            self.collectionView.reloadData()
            
            self.navigationItem.title = self.currentUser?.userName
            
          
        }
    }
    

  

}

extension UserProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    
   
}
