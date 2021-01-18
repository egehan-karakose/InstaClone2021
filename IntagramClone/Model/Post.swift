//
//  Post.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 18.01.2021.
//

import Firebase
import Foundation


struct Post {
    
    let User: User
    let UserID: String?
    let  CommentPhotoURL: String?
    let Comment : String?
    let PhotoWidth: Double?
   let  PhotoHeight: Double?
   let CommentDate : Timestamp?
    
    
    init(user: User , data : [String: Any]) {
        self.User = user
        self.UserID = data["UserID"] as? String
        self.CommentPhotoURL = data["CommentPhotoURL"] as? String
        self.Comment = data["Comment"] as? String
        self.PhotoWidth = data["PhotoWidth"] as? Double
        self.PhotoHeight = data["PhotoHeight"] as? Double
        self.CommentDate = data["CommentDate"] as? Timestamp
    }
}
