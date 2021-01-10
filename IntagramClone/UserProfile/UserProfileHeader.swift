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
            guard let url = URL(string: currentUser?.pofilePhotoURL ?? "") else {return}
            imageProfile.sd_setImage(with: url, completed: nil)
            userNameLabel.text = currentUser?.userName
        }
    }
    
    
    let editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.layer.borderWidth = 1
        button.setTitleColor(.label, for: .normal)
        button.layer.borderColor = UIColor.label.cgColor
        button.titleLabel?.font  = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        
        return button
    }()
    
    
    
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
