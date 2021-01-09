//
//  User.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 9.01.2021.
//

import Foundation


struct  User {
    let userName: String
    let userId: String
    let pofilePhotoURL: String

    
    init(userData : [String : Any]) {
        self.userName = userData["UserName"] as? String ?? ""
        self.userId = userData["UserId"] as? String ?? ""
        self.pofilePhotoURL = userData["ProfilePhotoURL"] as? String ?? ""
    }

}
