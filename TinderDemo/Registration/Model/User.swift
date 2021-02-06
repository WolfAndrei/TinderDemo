//
//  User.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 23.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

struct User: ProducesCardViewModel {
    
    var name: String?
    var age: Int?
    var profession: String?
    var image1Url: String?
    var image2Url: String?
    var image3Url: String?
    var uid: String?
    var minSeekingAge: Int?
    var maxSeekingAge: Int?
    
    init(userDictionary: [String: Any]) {
        self.name = userDictionary["fullName"] as? String ?? ""
        self.image1Url = userDictionary["image1Url"] as? String
        self.image2Url = userDictionary["image2Url"] as? String
        self.image3Url = userDictionary["image3Url"] as? String
        self.uid = userDictionary["uid"] as? String ?? ""
        self.age = userDictionary["age"] as? Int
        self.profession = userDictionary["profession"] as? String
        self.minSeekingAge = userDictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = userDictionary["maxSeekingAge"] as? Int
    }
    
    
    
    func toCardViewModel() -> CardViewModel {
        
        let nameAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 30, weight: .bold), .foregroundColor : UIColor.white]
        let ageAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 25, weight: .thin), .foregroundColor : UIColor.white]
        let professionAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 20, weight: .regular), .foregroundColor : UIColor.white]
        
        let ageString = age != nil ? "\(age!)" : "N/A"
        let professionString = profession != nil ? "\(profession!)" : "Not avaiable"
        
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: nameAttributes)
        attributedText.append(NSAttributedString(string: " \(ageString)\n", attributes: ageAttributes))
        attributedText.append(NSAttributedString(string: professionString, attributes: professionAttributes))
        
        var imageURLs = [String]()
        if let image1Url = image1Url {imageURLs.append(image1Url)}
        if let image2Url = image2Url {imageURLs.append(image2Url)}
        if let image3Url = image3Url {imageURLs.append(image3Url)}
        
        return CardViewModel(uid: self.uid ?? "", imageURLs: imageURLs, attributedString: attributedText, textAlignment: .left)
        
        
    }
    
    
    
    
    
}
