//
//  Match.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 30.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import Foundation

class Match: NSObject {
    let name, profileImageURL, uid: String
    
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}

