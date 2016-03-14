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
    
    func deleteFromParse(setName: String) {
        let query = PFQuery(className: "Set")
        query.whereKey("username", equalTo: username)
        query.whereKey("set", equalTo: setName)
        do {
            let objects = try query.findObjects()
            try objects[0].delete()
            
            let query = PFQuery(className: "Flashcard")
            query.whereKey("username", equalTo: username)
            query.whereKey("set", equalTo: setName)
            let cards = try query.findObjects()
            for card in cards {
                try card.delete()
            }
        } catch {}
    }
    
    func saveToParse(setName: String, flashcards: [FlashcardModel], dueDate: NSDate?) {
        // Making sure we don't have duplicate sets
        let query = PFQuery(className: "Set")
        query.whereKey("username", equalTo: username)
        query.whereKey("set", equalTo: setName)
        do {
            let objects = try query.findObjects()
            if objects.count == 0 {
                // No objects, so save it to Parse.
                let setObject = PFObject(className: "Set")
                setObject["username"] = username
                setObject["set"] = setName
                if dueDate != nil {
                    setObject["dueDate"] = dueDate
                }
                else {
                    setObject["dueDate"] = NSDate.distantFuture()
                }
                try setObject.save()
            }
            else {
                // The set is already there, so just update the due date.
                if dueDate != nil {
                    objects[0]["dueDate"] = dueDate
                }
                else {
                    objects[0]["dueDate"] = NSDate.distantFuture()
                }
                try objects[0].save()
            }
            
            for card in flashcards {
                // Finding the card in Parse to make sure we don't have duplicates.
                let query = PFQuery(className: "Flashcard")
                query.whereKey("username", equalTo: username)
                query.whereKey("set", equalTo: setName)
                query.whereKey("term", equalTo: card.term)
                let objects = try query.findObjects()
                if objects.count == 0 {
                    // No objects, so save it to Parse.
                    let cardObject = PFObject(className: "Flashcard")
                    cardObject["username"] = username
                    cardObject["set"] = setName
                    cardObject["term"] = card.term
                    cardObject["definition"] = card.definition
                    try cardObject.save()
                }
                else {
                    // There is already an object, so update the definition
                    objects[0]["definition"] = card.definition
                    try objects[0].save()
                }
            }
        } catch {}
    }
    
    func saveToParseFromQuizlet(setName: String, cardsInSet: JSON) {
        // Finding the set in Parse to make sure we don't have duplicates.
        let query = PFQuery(className: "Set")
        query.whereKey("username", equalTo: username)
        query.whereKey("set", equalTo: setName)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                if let objects = objects {
                    if objects.count == 0 {
                        // No objects, so save it to Parse.
                        let setObject = PFObject(className: "Set")
                        setObject["username"] = self.username
                        setObject["set"] = setName
                        setObject.saveInBackground()
                    }
                    for (_, card) in cardsInSet {
                        // Finding the card in Parse to make sure we don't have duplicates.
                        let query = PFQuery(className: "Flashcard")
                        query.whereKey("username", equalTo: self.username)
                        query.whereKey("set", equalTo: setName)
                        query.whereKey("term", equalTo: card["term"].stringValue)
                        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                            if error == nil {
                                if let objects = objects {
                                    if objects.count == 0 {
                                        // No objects, so save it to Parse.
                                        let cardObject = PFObject(className: "Flashcard")
                                        cardObject["username"] = self.username
                                        cardObject["set"] = setName
                                        cardObject["term"] = card["term"].stringValue
                                        cardObject["definition"] = card["definition"].stringValue
                                        cardObject.saveInBackground()
                                    }
                                    else {
                                        // There is already an object, so update the definition
                                        objects[0]["definition"] = card["definition"].stringValue
                                        objects[0].saveInBackground()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}