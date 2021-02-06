//
//  PhotoController.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 28.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class PhotoController: UIViewController {
    
    //MARK: - INITIALIZATION
    
    init(imageURL: String) {
        if let url = URL(string: imageURL) {
            imageView.sd_setImage(with: url, completed: nil)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup imageview
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        imageView.fillSuperview()
    }
    
    //MARK: - UI ELEMENTS
    
    let imageView = UIImageView(image: nil)
    
}
