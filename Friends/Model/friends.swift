//
//  friends.swift
//  Friends
//
//  Created by VALID on 5/30/19.
//  Copyright © 2019 VALID Colombia. All rights reserved.
//

struct Friend {
    let firstname : String
    let lastname : String
    let phonenumber : String
    let id : Int
}

//Mark: Extension Friend
/* Put init function to extension so default constructor*/

extension Friend {
    init?(json: JSON) {
    
        guard let id = json["id"] as? Int,
            let firstname = json["firstname"] as? String,
            let lastname = json["lastname"] as? String,
            let phonenumber = json["phonenumber"] as? String else {
            return nil
        }
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.phonenumber = phonenumber        
    }
}
