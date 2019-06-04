//
//  Result.swift
//  Friends
//
//  Created by VALID on 5/30/19.
//  Copyright © 2019 VALID Colombia. All rights reserved.
//

enum Result <T, U> where U: Error {
    case success(payload: T)
    case failure(U?)
}
