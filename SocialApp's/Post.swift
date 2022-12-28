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
