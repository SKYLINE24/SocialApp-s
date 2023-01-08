//
//  Paylasimlar.swift
//  SocialApp's
//
//  Created by Erbil Can on 22.12.2022.
//

import Foundation
class Post {
    
    var username : String
    var yorum : String
    var gorselUrl : String
    
    init(username: String, yorum: String, gorselUrl: String) {
        self.username = username
        self.yorum = yorum
        self.gorselUrl = gorselUrl
    }
}
class UserProfilePost {
    
    var gorselUrl : String
    
    init( gorselUrl: String) {
        
        self.gorselUrl = gorselUrl
    }
    
    
}
class UserProfileSearch{
    var userImageUrl : String
    var username : String
    
    init(userImageUrl: String, username: String) {
        self.userImageUrl = userImageUrl
        self.username = username
    }
}
