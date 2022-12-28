//
//  User.swift
//  SocialApp's
//
//  Created by Erbil Can on 26.12.2022.
//

import Foundation
class User {
    
    var email : String
    var profileDescription : String
    var profileImage : String
    var userID : String
    var username : String
    
    
    init(email: String, profileDescription: String, profileImage: String, userID : String, username : String) {
        self.email = email
        self.profileDescription = profileDescription
        self.profileImage = profileImage
        self.userID = userID
        self.username = username
    }
    
}
class PostUser {
    var profileImage : String
    var username : String
    
    
    init(username : String, yorum : String) {
        
        self.yorum = yorum
        self.username = username
    }
    
}
