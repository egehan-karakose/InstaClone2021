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
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPosts), name: SharePhotoController.updateNotification, object: nil)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MainPagePostCell.self, forCellWithReuseIdentifier: MainPagePostCell.identifier)
        
        setButtons()
        
        getUser()
        
        getFollowingUserId()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc fileprivate func refreshPosts(){
        
        
        posts.removeAll()
        collectionView.reloadData()
        getFollowingUserId()
        getUser()
        
        
        
    }
    
    fileprivate func getFollowingUserId(){
        guard let uId = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("Following").document(uId).addSnapshotListener { (snap, error) in
            if let error = error {
                print("Failed to get following id : \(error.localizedDescription)")
                return
            }
            
            guard let postDict = snap?.data() else {return}
            postDict.forEach { (key, value) in
                Firestore.initiateUser(userId: key) { (user) in
                    self.getPosts(user: user)
                }
            }
            
            
        }
    }
    
    fileprivate func getPosts(user : User){
        
        
        Firestore.firestore().collection("Comments").document(user.userId).collection("Posts").order(by: "CommentDate", descending: false)
            .addSnapshotListener { (snapshot, error) in
                
                self.collectionView.refreshControl?.endRefreshing()
                
                if let error = error {
                    print("Failed to get posts : \(error.localizedDescription)")
                }
                
                
                snapshot?.documentChanges.forEach({ (docChange) in
                    if docChange.type == .added{
                        let postData = docChange.document.data()
                        let post = Post(user: user, data: postData)
                        self.posts.append(post)
                    }
                })
                
                self.posts.reverse()
                self.posts.sort { (p1, p2) -> Bool in
                    return p1.CommentDate.dateValue().compare(p2.CommentDate.dateValue()) == .orderedDescending
                }
                self.collectionView.reloadData()
                
                
                
            }
    }
    
    fileprivate func setButtons(){
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "Logo_Instagram2").withTintColor(UIColor.label, renderingMode: .alwaysOriginal))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Kamera").withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(manageCamera))
    }
    
    
    
    @objc fileprivate func manageCamera(){
        let cameraContoller = CameraController()
        cameraContoller.modalPresentationStyle = .fullScreen
        present(cameraContoller, animated: true, completion: nil)
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainPagePostCell.identifier, for: indexPath) as! MainPagePostCell
        
        cell.post  = posts[indexPath.row]
        return cell
    }
    
    
    
    fileprivate func getUser(userId: String = ""){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        
        let uID = userId == "" ? currentUserId : userId
        
        Firestore.firestore().collection("Users").document(uID).getDocument { (snapshot, error) in
            if let error = error {
                print("Faid to get user data \(error.localizedDescription)")
            }
            
            guard let userData = snapshot?.data() else {return}
            
            self.currentUser = User(userData: userData)
            
            guard let user = self.currentUser else {return}
            self.getPosts(user: user)
            
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
