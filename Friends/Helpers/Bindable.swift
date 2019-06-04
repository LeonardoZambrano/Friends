//
//  Bindable.swift
//  Friends
//
//  Created by VALID on 5/31/19.
//  Copyright © 2019 VALID Colombia. All rights reserved.
//

class Bindable<T> {
    typealias Listener = ((T) -> Void)
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    init(_ v: T) {
        self.value = v
    }
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
