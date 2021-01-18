//
//  MainPageViewController.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 18.01.2021.
//

import UIKit
import Firebase


class MainPageViewController: UICollectionViewController {
    
    var currentUser : User?
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MainPagePostCell.self, forCellWithReuseIdentifier: MainPagePostCell.identifier)
  
        setButtons()

        getUser()
    }
    
    fileprivate func getPosts(){
        posts.removeAll()
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        guard let currentUser = currentUser else {return}
        Firestore.firestore().collection("Comments").document(currentUserID).collection("Posts").order(by: "CommentDate", descending: false)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Failed to get posts : \(error.localizedDescription)")
                }
                
                snapshot?.documentChanges.forEach({ (docChange) in
                    if docChange.type == .added{
                        let postData = docChange.document.data()
                        let post = Post(user: currentUser, data: postData)
                        self.posts.append(post)
                    }
                })
                
                self.posts.reverse()
                self.collectionView.reloadData()
                
                
                
            }
    }
    
    fileprivate func setButtons(){
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "Logo_Instagram2").withTintColor(UIColor.label, renderingMode: .alwaysOriginal))
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainPagePostCell.identifier, for: indexPath) as! MainPagePostCell

        cell.post  = posts[indexPath.row]
        return cell
    }
    
  
    
    fileprivate func getUser(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("Users").document(currentUserId).getDocument { (snapshot, error) in
            if let error = error {
                print("Faid to get user data \(error.localizedDescription)")
            }
            
            guard let userData = snapshot?.data() else {return}
            
            self.currentUser = User(userData: userData)
            
            self.getPosts()
            
        }
    }
    


}
extension MainPageViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = 175
        height += view.frame.width
        return CGSize(width: view.frame.width, height: height)
    }
}
