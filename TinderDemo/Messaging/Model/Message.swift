//
//  Message.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 31.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    let text, fromId, toId : String
    let timeStamp: Timestamp
    let isMyMessage: Bool
    
    init(dictionary: [String : Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.isMyMessage = Auth.auth().currentUser!.uid == self.fromId
        
    }
}


