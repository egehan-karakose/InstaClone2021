//
//  SharePhotoController.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 14.01.2021.
//

import UIKit
import JGProgressHUD
import Firebase

class SharePhotoController : UIViewController {
    
    
    
    
    var choosenPhoto: UIImage? {
        didSet{
            imageShare.image = choosenPhoto
        }
    }
    
    
    
    let txtComment : UITextView = {
        let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 15)
        
        return text
    }()
    
    
    let imageShare : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        
        return image
    }()
    
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareButtonPressed))
        
        
        createPhotoCommentSection()
    }
    
    
    fileprivate func createPhotoCommentSection(){
        
        let shareView = UIView()
        shareView.backgroundColor = .systemBackground
        view.addSubview(shareView)
        
        shareView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 120)
        
        
        view.addSubview(imageShare)
        imageShare.anchor(top: shareView.topAnchor, bottom: shareView.bottomAnchor, leading: shareView.leadingAnchor, trailing: nil, paddingTop: 8, paddingBottom: -8, paddingLeft: 8, paddingRight: 0, width: 85, height: 0)
        
        view.addSubview(txtComment)
        txtComment.anchor(top: shareView.topAnchor, bottom: shareView.bottomAnchor, leading: imageShare.trailingAnchor, trailing: shareView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 5, paddingRight: 0, width: 0, height: 0)
        
    }
    
    
    @objc fileprivate func shareButtonPressed(){
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Comment Uploading"
        hud.show(in: self.view)
        
        let photoName = UUID().uuidString
        
        guard  let sharePhoto = choosenPhoto else {
            return
        }
        let photoData = sharePhoto.jpegData(compressionQuality: 0.8) ?? Data()
        
        let ref = Storage.storage().reference(withPath: "/Comments/\(photoName)")
        
        ref.putData(photoData, metadata: nil) { (_, error) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Fail to upload Photo \(error.localizedDescription)")
                hud.textLabel.text = "Photo Could Not Uploaded"
                hud.dismiss(afterDelay: 2)
                return
            }
            
            print("Comment Photo Successfully Uploaded")
            ref.downloadURL { (url, error) in
                hud.textLabel.text = "Comment Uploaded.."
                hud.dismiss(afterDelay: 2)
                hud.dismiss()
                if let error = error {
                    print("Fail to get url of uploaded Photo \(error.localizedDescription)")
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    return
                }
                
                print("Url of uploaded photo: \(url?.absoluteString ?? "") ")
                if let url = url {
                    self.saveCommentFS(photoURL: url.absoluteString)
                }


                }
        }
        
        
    }
    
    fileprivate func saveCommentFS(photoURL: String){
        
        
        guard let commentPhoto = choosenPhoto,
              let comment = txtComment.text, comment.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
        else {
            return
            
        }
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        let data = ["UserID": currentUserID,
        "CommentPhotoURL": photoURL,
        "Comment" : comment,
        "PhotoWidth": commentPhoto.size.width,
        "PhotoHeight": commentPhoto.size.height,
        "CommentDate" :Timestamp(date: Date())] as [String : Any]
        
        var ref : DocumentReference? = nil
        
        ref = Firestore.firestore().collection("Comments").document(currentUserID).collection("Posts")
            .addDocument(data: data, completion: { (error) in
            if let error = error {
                print("Fail to save comment \(error.localizedDescription)")
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
            
            print("Comment successfully added docID : \(ref?.documentID ?? "")")
            self.dismiss(animated: true, completion: nil)
        })
        
        
        
    }
}
