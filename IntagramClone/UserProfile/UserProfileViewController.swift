//
//  UserProfileViewController.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 9.01.2021.
//

import UIKit
import Firebase
import SDWebImage


class UserProfileViewController: UICollectionViewController {
    
    
    
    var userID : String?
    
    
    var posts = [Post]()
    
    var currentUser : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        getUser()
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UserProfileHeader.identifier)
        
        
        collectionView.register(UserPostPhotoCell.self, forCellWithReuseIdentifier: UserPostPhotoCell.identifier)
        
        collectionView.backgroundColor  = .systemBackground
        createLogOutButton()
        
    }
    
    
    fileprivate func getPostsFS(){
        
//        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        
        guard let currentUserId = self.currentUser?.userId else {return}
        guard let currentUser = currentUser else {return}
                
        Firestore.firestore().collection("Comments").document(currentUserId).collection("Posts").order(by: "CommentDate", descending: false)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Failed to get Posts : \(error.localizedDescription)")
                }
                
                snapshot?.documentChanges.forEach({ (docChange) in
                    if docChange.type == .added {
                        let postData = docChange.document.data()  // post data
                        let post = Post(user: currentUser, data: postData)
                        self.posts.append(post)
                    }
                })
                
                //all posts added to posts array
                self.posts.reverse()
                self.collectionView.reloadData()
            }
        
    }
    
    fileprivate func createLogOutButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Ayarlar").withTintColor(UIColor.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(logOut))
    }
    
    
    @objc fileprivate func logOut(){
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Log Out", style: .destructive) { (_) in
            
            guard let _ = Auth.auth().currentUser?.uid else {return}
            do{
                try Auth.auth().signOut()
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
                
            }catch let error {
                print("Failed to log out \(error.localizedDescription)")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        
        
        present(alertController, animated: true, completion: nil)
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 5) / 3
        
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPostPhotoCell.identifier, for: indexPath) as! UserPostPhotoCell
        
        postCell.post = posts[indexPath.row]
        
        return postCell
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UserProfileHeader.identifier, for: indexPath) as! UserProfileHeader
        
        header.currentUser = currentUser
        
        return header
    }
    
    
    
    
    fileprivate func getUser(){
        
        
//        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let userId = userID ?? Auth.auth().currentUser?.uid ?? ""
        
        Firestore.firestore().collection("Users").document(userId).getDocument { (snapshot, error) in
            if let error = error {
                print("Fail to get user data : ",error.localizedDescription)
            }
            
            guard let data = snapshot?.data() else {
                return
            }
            
            self.currentUser = User(userData: data)
            self.getPostsFS()
            self.navigationItem.title = self.currentUser?.userName
            
            
        }
    }
    
    
    
    
}

extension UserProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    
    
}
