//
//  CommentsController.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 22.03.2021.
//


import UIKit
import Firebase


class CommentsController : UICollectionViewController {
    
    var choosenPost : Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    let txtComment : UITextField = {
        let txtComment = UITextField()
        txtComment.placeholder = "Write a Comment.."
        return txtComment
    }()
    
    lazy var containerView : UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .systemBackground
        containerView.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
        
        let sendCommentButton = UIButton(type: .system)
        sendCommentButton.setTitle("Send", for: .normal)
        sendCommentButton.setTitleColor(.label, for: .normal)
        sendCommentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        sendCommentButton.addTarget(self, action: #selector(sendCommentButtonPressed), for: .touchUpInside)
        
        containerView.addSubview(sendCommentButton)
        sendCommentButton.anchor(top: containerView.safeAreaLayoutGuide.topAnchor, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, leading: nil, trailing: containerView.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: -15, width: 80, height: 0)
        
        
        containerView.addSubview(txtComment)
        
        txtComment.anchor(top: containerView.safeAreaLayoutGuide.topAnchor, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, leading: containerView.safeAreaLayoutGuide.leadingAnchor, trailing: sendCommentButton.leadingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: 0, height: 0)
        
        return containerView
    }()
    
    
    
    @objc fileprivate func sendCommentButtonPressed(){
        
        if let comment = txtComment.text , comment.isEmpty {
            return
        }
        
        guard  let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        guard let postID = self.choosenPost?.id else { return }
        
        let message = ["commentMessage": txtComment.text ?? "",
                       "date": Date().timeIntervalSince1970,
                       "UserId" : currentUserId] as [String: Any]
        
        Firestore.firestore().collection("SubComments").document(postID).collection("Added_Comments").document().setData(message) {(error) in
            if let error = error {
                print("Failed to save comment in firestore, \(error.localizedDescription)")
                return
            }
            print("Comment saved database")
            self.txtComment.text = ""
        }
        
    }
    
    
    override var inputAccessoryView: UIView?{
        get{
            return containerView
        }
    }
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
}
