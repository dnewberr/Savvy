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
    
    func getClosestDueDateSet() -> String {
        var cdds = ""
        var due = NSDate.distantFuture()
        
        let query = PFQuery(className: "Set")
        query.whereKey("username", equalTo: username)
        do {
            let objects = try query.findObjects()
            for obj in objects {
                let earlierDate = due.earlierDate(obj["dueDate"] as! NSDate)
                if earlierDate != due && earlierDate != earlierDate.earlierDate(NSDate.init()) {
                    due = earlierDate
                    cdds = obj["set"] as! String
                }
            }
        } catch {}
        
        return cdds
    }
    
    func getDueDateForSet(set: String) -> NSDate? {
        let query = PFQuery(className: "Set")
        query.whereKey("username", equalTo: username)
        query.whereKey("set", equalTo: set)
        do {
            let objects = try query.findObjects()
            return objects[0]["dueDate"] as? NSDate
        } catch {}
        
        return nil
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
    
    func getBadges() -> [String] {
        var result: [String] = []
        
        let query = PFQuery(className: "Badges")
        query.whereKey("username", equalTo: username)
        query.whereKey("obtained", equalTo: true)
        do {
            let objects = try query.findObjects()
            for obj in objects {
                result.append(obj["badgeName"] as! String)
            }
        } catch {}
        
        return result
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
    
    func saveBadgeToParse(badgeName: String) {
        let query = PFQuery(className: "Badges")
        query.whereKey("username", equalTo: username)
        query.whereKey("badgeName", equalTo: badgeName)
        do {
            let objects = try query.findObjects()
            if objects.count == 0 {
                // No objects, so save it to Parse.
                let setObject = PFObject(className: "Badges")
                setObject["username"] = username
                setObject["obtained"] = true
                setObject["badgeName"] = badgeName
                try setObject.save()
            }
            else {
                objects[0]["obtained"] = true
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
            
            for (ind, card) in flashcards.enumerate() {
                // Finding the card in Parse to make sure we don't have duplicates.
                let query = PFQuery(className: "Flashcard")
                query.whereKey("username", equalTo: username)
                query.whereKey("set", equalTo: setName)
                query.whereKey("cardNumber", equalTo: ind)
                let objects = try query.findObjects()
                if objects.count == 0 {
                    // No objects, so save it to Parse.
                    let cardObject = PFObject(className: "Flashcard")
                    cardObject["username"] = username
                    cardObject["set"] = setName
                    cardObject["cardNumber"] = ind
                    cardObject["term"] = card.term
                    cardObject["definition"] = card.definition
                    try cardObject.save()
                }
                else {
                    // There is already an object, so update the term and definition
                    objects[0]["term"] = card.term
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
                        setObject["dueDate"] = NSDate.distantFuture()
                        setObject.saveInBackground()
                    }
                    
                    for (ind, (_, card)) in cardsInSet.enumerate() {
                        // Finding the card in Parse to make sure we don't have duplicates.
                        let query = PFQuery(className: "Flashcard")
                        query.whereKey("username", equalTo: self.username)
                        query.whereKey("set", equalTo: setName)
                        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                            if error == nil {
                                if let objects = objects {
                                    let cardObject = PFObject(className: "Flashcard")
                                    cardObject["username"] = self.username
                                    cardObject["set"] = setName
                                    cardObject["cardNumber"] = objects.count + ind
                                    cardObject["term"] = card["term"].stringValue
                                    cardObject["definition"] = card["definition"].stringValue
                                    cardObject.saveInBackground()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}