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
    var username : String
    
    init (username : String) {
        self.username = username
    }
    
    func getSets() -> [String] {
        var arr: [String] = []
        let query = PFQuery(className: "Set")
        query.whereKey("username", equalTo: username)
        do {
            let objects = try query.findObjects()
            for obj in objects {
                arr.append(obj["set"] as! String)
            }
        } catch {}
        
        return arr
    }
    
    func getCardsForSet(setName: String) -> [FlashcardModel] {
        var arr: [FlashcardModel] = []
        let query = PFQuery(className: "Flashcard")
        query.whereKey("username", equalTo: username)
        query.whereKey("set", equalTo: setName)
        do {
            let objects = try query.findObjects()
            for obj in objects {
                arr.append(FlashcardModel.init(newTerm: obj["term"] as! String, newDef: obj["definition"] as! String))
            }
        } catch {}
        
        return arr
    }
}