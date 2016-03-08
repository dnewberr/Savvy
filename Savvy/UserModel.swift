//
//  UserModel.swift
//  Savvy
//
//  Created by Cody Rhoads on 3/8/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import Foundation
import Parse

class UserModel {
    var username : String?
    
    init (username : String) {
        self.username = username
    }
    
    func getSets() -> [String] {
        var arr: [String] = []
        if let username = username {
            let query = PFQuery(className: "Set")
            query.whereKey("username", equalTo: username)
            do {
                let objects = try query.findObjects()
                for obj in objects {
                    arr.append(obj["set"] as! String)
                }
            } catch {}
        }
        
        return arr
    }
}