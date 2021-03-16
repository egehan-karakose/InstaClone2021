//
//  SearchUserCell.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 22.01.2021.
//

import UIKit


class SearchUserCell : UICollectionViewCell {
    
    var user : User? {
        didSet{
            userNameLabel.text = user?.userName
            if let url = URL(string: user?.pofilePhotoURL ?? ""){
                profileImage.sd_setImage(with: url, completed: nil)
            }
        }
    }
    
    
    static let identifier = "SearchUserCell"
    
    
    let userNameLabel : UILabel = {
        let label = UILabel()
        label.text = "User Name"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        return label
    }()
    
    let profileImage : UIImageView = {
        let image =  UIImageView()
        image.backgroundColor = .yellow
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       
        
        addSubview(profileImage)
        addSubview(userNameLabel)
        
        
        profileImage.anchor(top: nil, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 55, height: 55)
        profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImage.layer.cornerRadius = 55 / 2
        
        userNameLabel.anchor(top: topAnchor, bottom: bottomAnchor, leading: profileImage.trailingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 0, height: 0)
        
        let seperator = UIView()
        seperator.backgroundColor = UIColor(white: 1, alpha: 0.45)
        addSubview(seperator)
        seperator.anchor(top: nil, bottom: bottomAnchor, leading: userNameLabel.leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.2)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
