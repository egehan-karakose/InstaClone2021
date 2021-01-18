//
//  UserPostPhotoCell.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 18.01.2021.
//

import Foundation
import UIKit


class UserPostPhotoCell : UICollectionViewCell {
    
    
    var post : Post? {
        didSet{
            if let url = URL(string: post?.CommentPhotoURL ?? ""){
                photo.sd_setImage(with: url, completed: nil)
            }
           
        }
    }
    
    
    static var identifier =  "UserPostPhotoCell"
    
    
    let photo : UIImageView = {
        
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
        
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photo)
        
        photo.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
