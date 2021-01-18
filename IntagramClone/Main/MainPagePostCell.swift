//
//  MainPagePostCell.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 18.01.2021.
//

import Foundation
import UIKit
import SDWebImage

class MainPagePostCell : UICollectionViewCell{
    var post : Post? {
        didSet{
            
            guard let url = post?.CommentPhotoURL,
                  let photoUrl = URL(string:  url) else{
                return
            }
            
            photo.sd_setImage(with: photoUrl, completed: nil)
            
            
            userNameLabel.text = post?.User.userName
            
            guard let pURL =  post?.User.pofilePhotoURL,
                  let profilePhotoUrl = URL(string: pURL) else {
                return
            }
            
            profilePhoto.sd_setImage(with: profilePhotoUrl, completed: nil)
            
            
            attrPostMessage()
            
            
        }
    }
    
    
    
    
    static let identifier = "MainPagePostCell"
    
    
    
    let postLabel : UILabel = {
        let label = UILabel()
        let attrText = NSMutableAttributedString(string: "User Name", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attrText.append(NSAttributedString(string: " This message have to be quite long to check Number of lines", attributes: [.font : UIFont.systemFont(ofSize: 14) ]))
        
        attrText.append(NSAttributedString(string: "\n\n", attributes: [.font: UIFont.systemFont(ofSize: 5)]))
        
        attrText.append(NSAttributedString(string: "1 week ago", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.gray]))
        
        label.attributedText = attrText
        label.numberOfLines = 0
        return label
    }()
    
    let userNameLabel : UILabel = {
        let label = UILabel()
        label.text = "User Name"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    
    let settingsButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.label, for: .normal)
        
        return button
    }()
    
    let bookmarkButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Yer_Isareti").withTintColor(.label).withRenderingMode(.alwaysOriginal), for: .normal)
        
        return button
    }()
    
    let likeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Begeni_Secili_Degil").withTintColor(.label).withRenderingMode(.alwaysOriginal), for: .normal)
        
        return button
    }()
    
    let sendButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Gonder").withTintColor(.label).withRenderingMode(.alwaysOriginal), for: .normal)
        
        
        return button
    }()
    
    let commentButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Yorum").withTintColor(.label).withRenderingMode(.alwaysOriginal), for: .normal)
        
        return button
    }()
    
    let profilePhoto: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .link
        image.clipsToBounds = true
        return image
        
    }()
    
    
    
    
    let photo: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photo)
        addSubview(profilePhoto)
        addSubview(userNameLabel)
        addSubview(settingsButton)
        
        profilePhoto.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 8, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 40, height: 40)
        profilePhoto.layer.cornerRadius = 20
        
        userNameLabel.anchor(top: topAnchor, bottom:  photo.topAnchor, leading: profilePhoto.trailingAnchor, trailing: settingsButton.leadingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)
        
        settingsButton.anchor(top: topAnchor, bottom:  photo.topAnchor, leading: nil, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 45, height: 0)
        
        
        photo.anchor(top: profilePhoto.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        photo.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        
        interactionButtons()
        
        
    }
    
    
    fileprivate func attrPostMessage(){
        
        guard let post = self.post else{ return }
        
        let attrText = NSMutableAttributedString(string: post.User.userName, attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attrText.append(NSAttributedString(string: " \(post.Comment ?? "")", attributes: [.font : UIFont.systemFont(ofSize: 14) ]))
        
        attrText.append(NSAttributedString(string: "\n\n", attributes: [.font: UIFont.systemFont(ofSize: 5)]))
        
        attrText.append(NSAttributedString(string: "1 week ago", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.gray]))
        
        postLabel.attributedText = attrText

        
    }
    
    
    fileprivate func interactionButtons(){
        let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,sendButton])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.anchor(top: photo.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 120, height: 50)
        
        addSubview(bookmarkButton)
        bookmarkButton.anchor(top: photo.bottomAnchor, bottom: nil, leading: nil, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 40, height: 50)
        
        
        addSubview(postLabel)
        postLabel.anchor(top: likeButton.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: -8, width: 0, height: 0)
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
