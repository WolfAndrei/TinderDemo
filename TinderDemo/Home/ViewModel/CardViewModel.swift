//
//  CardViewModel.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 23.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    
    let imageURLs: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    let uid: String
    
    fileprivate var imageIndex: Int = 0 {
        didSet {
            let imageURL = imageURLs[imageIndex]
            imageIndexObserver?(imageIndex, imageURL)
        }
    }
    
    init(uid: String, imageURLs: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.uid = uid
        self.imageURLs = imageURLs
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    //Reactive programming
    var imageIndexObserver: ((Int, String?)->())?
    
    
    func advanceToNextPhoto() {
        imageIndex = min(imageURLs.count - 1, imageIndex + 1)
    }
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
    
    
}
