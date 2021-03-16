//
//  UserProfileHeader.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 9.01.2021.
//

import Foundation
import UIKit
import Firebase
import SDWebImage

class UserProfileHeader : UICollectionViewCell {
    
    static let identifier = "UserProfileHeader"
    
    var currentUser : User? {
        didSet{
            setFollowButton()
            guard let url = URL(string: currentUser?.pofilePhotoURL ?? "") else {return}
            imageProfile.sd_setImage(with: url, completed: nil)
            userNameLabel.text = currentUser?.userName
        }
    }
    
    
    fileprivate func setFollowButton(){
        guard let authUserId = Auth.auth().currentUser?.uid else { return }
        guard let currentUser = currentUser?.userId else { return }
        
        
        if currentUser != authUserId {
            
            
            Firestore.firestore().collection("Following").document(authUserId).getDocument { (snapshot, error) in
                if let error = error {
                    print( "Failed to get following data  : \(error.localizedDescription)" )
                    return
                }
                guard let followingData = snapshot?.data() else { return }
                if let data = followingData[currentUser] {
                    let follow = data as! Int
                    print(follow)
                    if follow == 1 {
                        self.editProfileButton.setTitle("Unfollow", for: .normal)
                    }
                    
                } else {
                    
                    self.editProfileButton.setTitle("Follow", for: .normal)
                    self.editProfileButton.backgroundColor = UIColor.toRGB(red: 20, green: 155, blue: 240)
                    self.editProfileButton.setTitleColor(.white, for: .normal)
                    self.editProfileButton.layer.borderColor =  UIColor(white: 0, alpha: 0.3).cgColor
                    self.editProfileButton.layer.borderWidth = 1
                    
                }
            }
            
            
            
            
        } else {
            self.editProfileButton.setTitle("Edit Profile", for: .normal)
        }
    }
    
    lazy var editProfileButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.setTitleColor(.label, for: .normal)
        button.layer.borderColor = UIColor.label.cgColor
        button.titleLabel?.font  = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(editProfile_Follow_Button), for: .touchUpInside)
        
        return button
    }()
    
    
    @objc fileprivate func editProfile_Follow_Button(){
        guard let authUserId = Auth.auth().currentUser?.uid else { return }
        guard let currentUser = currentUser?.userId else { return }
        
        if currentUser != authUserId {
        
        if editProfileButton.titleLabel?.text == "Unfollow" {
            Firestore.firestore().collection("Following").document(authUserId).updateData([currentUser : FieldValue.delete()]){ (error) in
                if let error = error {
                    print( "Failed to unfollow   : \(error.localizedDescription)" )
                    return
                }
                
                print("\(self.currentUser?.userName ?? "") unfollowed")
                self.editProfileButton.backgroundColor = UIColor.toRGB(red: 20, green: 155, blue: 240)
                self.editProfileButton.setTitleColor(.white, for: .normal)
                self.editProfileButton.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
                self.editProfileButton.layer.borderWidth = 1
                self.editProfileButton.setTitle("Follow", for: .normal)
    
            }
            return
        }
        
        let followedId = [currentUser : 1]
        
        
        
        Firestore.firestore().collection("Following").document(authUserId).getDocument { (snapshot, error) in
            if let error = error {
                print( "Failed to get following data  : \(error.localizedDescription)" )
                return
            }
            
            if snapshot?.exists == true {
                Firestore.firestore().collection("Following").document(authUserId).updateData(followedId) { (error) in
                    
                    if let error = error {
                        print( "Failed to follow update : \(error.localizedDescription)" )
                        return
                    }
                    print("User added followings")
                    self.editProfileButton.setTitle("Unfollow", for: .normal)
                    self.editProfileButton.layer.borderWidth = 1
                    self.editProfileButton.backgroundColor = .systemBackground
                    self.editProfileButton.setTitleColor(.label, for: .normal)
                    self.editProfileButton.layer.borderColor = UIColor.label.cgColor
                    self.editProfileButton.layer.cornerRadius = 5
                    self.editProfileButton.setTitleColor(.label, for: .normal)
                    self.editProfileButton.layer.borderColor = UIColor.label.cgColor
      
                }
            } else {
                Firestore.firestore().collection("Following").document(authUserId).setData(followedId){ (error) in
                    if let error = error {
                        print( "Failed to add following data : \(error.localizedDescription)" )
                        return
                    }
                    
                    print("User added followings")
                    self.editProfileButton.setTitle("Unfollow", for: .normal)
                    self.editProfileButton.layer.borderWidth = 1
                    self.editProfileButton.setTitleColor(.label, for: .normal)
                    self.editProfileButton.layer.borderColor = UIColor.label.cgColor
                    self.editProfileButton.layer.cornerRadius = 5
                    self.editProfileButton.setTitleColor(.label, for: .normal)
                    self.editProfileButton.layer.borderColor = UIColor.label.cgColor
                    
                }
            }
        }
        }
        
    }
    
    
    let postLabel : UILabel = {
        let label = UILabel()
       
        
        let attrText = NSMutableAttributedString(string: "10\n", attributes: [.font : UIFont.boldSystemFont(ofSize: 16)])
        
        attrText.append(NSAttributedString(string: "Post", attributes: [.foregroundColor : UIColor.label, .font : UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attrText
        
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    let followerLabel : UILabel = {
        let label = UILabel()
        
        
        let attrText = NSMutableAttributedString(string: "25\n", attributes: [.font : UIFont.boldSystemFont(ofSize: 16)])
        
        attrText.append(NSAttributedString(string: "Followers", attributes: [.foregroundColor : UIColor.label, .font : UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attrText
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    let followingLabel : UILabel = {
        let label = UILabel()
       
        let attrText = NSMutableAttributedString(string: "20\n", attributes: [.font : UIFont.boldSystemFont(ofSize: 16)])
        
        attrText.append(NSAttributedString(string: "Following", attributes: [.foregroundColor : UIColor.label, .font : UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attrText
        
        
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    
    
    let gridButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Izgara"), for: .normal)
        
        return button
        
    }()
    
    let listButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Liste"), for: .normal)
        button.tintColor = .label
        return button
        
    }()
    
    
    let bookMarkButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Yer_Isareti"), for: .normal)
        button.tintColor = .label
        return button
        
    }()
    
    let imageProfile : UIImageView = {
        
        let img = UIImageView()
        img.backgroundColor = .systemBackground
        img.clipsToBounds = true
        return img

    }()
    
    
    let userNameLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageProfile)
        addSubview(userNameLabel)
        addSubview(editProfileButton)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .systemBackground
        createToolBar()
        userProfileStatus()
        
        let size : CGFloat  = 90
        imageProfile.anchor(top: topAnchor, bottom: nil, leading: self.leadingAnchor, trailing: nil, paddingTop: 15, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: size, height: size)
        imageProfile.layer.cornerRadius = size / 2
        
        userNameLabel.anchor(top: imageProfile.bottomAnchor, bottom: gridButton.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, paddingTop: 5, paddingBottom: 0, paddingLeft: 15, paddingRight: 15, width: 0, height: 0)
        
        
        editProfileButton.anchor(top: postLabel.bottomAnchor, bottom: nil, leading: postLabel.leadingAnchor, trailing: followingLabel.trailingAnchor, paddingTop: 10, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 35)
        
        
    }
    
    fileprivate func userProfileStatus(){
        
        let stackView = UIStackView(arrangedSubviews: [postLabel,followerLabel,followingLabel])
        addSubview(stackView)
        stackView.distribution = .fillEqually
        
        stackView.anchor(top: topAnchor, bottom: nil, leading: imageProfile.trailingAnchor, trailing: self.trailingAnchor, paddingTop: 15, paddingBottom: 0, paddingLeft: 15, paddingRight: -15, width: 0, height: 50)
        
    }
    
    fileprivate func createToolBar(){
        
        let topSeperator = UIView()
        topSeperator.backgroundColor = UIColor.lightGray
        
        let bottomSeperator = UIView()
        bottomSeperator.backgroundColor = UIColor.lightGray
        
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookMarkButton])
        addSubview(stackView)
        addSubview(topSeperator)
        addSubview(bottomSeperator)
        
        stackView.distribution = .fillEqually
        stackView.anchor(top: nil, bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 60)
        
        
        topSeperator.anchor(top: stackView.topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.2)
        
        bottomSeperator.anchor(top: stackView.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.2)
        
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
