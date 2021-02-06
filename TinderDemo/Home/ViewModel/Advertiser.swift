//
//  Advertiser.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 23.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

struct Advertiser: ProducesCardViewModel {
    let title: String
    let brandName: String
    let posterPhotoNames: [String]
    
    func toCardViewModel() -> CardViewModel {
        
             let titleAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 34, weight: .heavy), .foregroundColor : UIColor.white]
             let brandAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 24, weight: .bold), .foregroundColor : UIColor.white]
             let attributedText = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
             attributedText.append(NSAttributedString(string: brandName, attributes: brandAttributes))
             
           
        return CardViewModel(uid: "", imageURLs: posterPhotoNames, attributedString: attributedText, textAlignment: .center
        )
        
        
    }
}
