//
//  Bindable.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 25.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import Foundation


class Bindable<T> {
    var value: T? {
        didSet{
            observer?(value)
        }
    }
    
    var observer: ((T?)->())?
    
    func bind(observer: @escaping (T?)->()) {
        self.observer = observer
    }
    
}
