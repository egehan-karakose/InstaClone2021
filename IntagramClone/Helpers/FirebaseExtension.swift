//
//  FirebaseExtension.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 17.03.2021.
//

import Firebase

extension Firestore{
    
    static func initiateUser(userId: String = "", completion: @escaping (User) -> ()) {
        var uId = ""
        if userId == "" {
            guard let currentUserId = Auth.auth().currentUser?.uid else {return}
            
            uId = currentUserId
        }else {
            uId = userId
        }
        
        Firestore.firestore().collection("Users").document(uId).getDocument { (snapshot, error) in
            if let error = error {
                print("Failed to get user data: \(error.localizedDescription)")
                return
            }
            
            guard let userData = snapshot?.data() else { return }
            let user = User(userData: userData)
            completion(user)
        }
        
        
        
    }
    
}
