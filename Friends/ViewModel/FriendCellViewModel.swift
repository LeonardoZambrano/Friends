//
//  FriendCellViewModel.swift
//  Friends
//
//  Created by VALID on 5/31/19.
//  Copyright © 2019 VALID Colombia. All rights reserved.
//
struct FriendCellViewModel {
    let firstname: String
    let lastname: String
    let phonenumber: String
    let id: Int
}

extension FriendCellViewModel {
    init(friend: Friend) {
        self.firstname = friend.firstname
        self.lastname = friend.lastname
        self.phonenumber = friend.phonenumber
        self.id = friend.id
    }
}
