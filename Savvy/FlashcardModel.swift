//
//  Flashcard.swift
//  Savvy
//
//  Created by Cody Rhoads on 2/9/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import Foundation

class FlashcardModel: Hashable {
    var term : String
    var definition : String
    var termSide: Bool
    var hashValue: Int {
        return (31 &* definition.hashValue) &+ term.hashValue
    }
    
    init() {
        term = ""
        definition = ""
        termSide = true
    }
    
    init(newTerm : String, newDef : String) {
        term = newTerm
        definition = newDef
        termSide = true
    }
    
    func equalTerms(lhs: String) -> Bool {
        return lhs == self.term
    }
    
    func equalDefs(lhs: String) -> Bool {
        return lhs == self.definition
    }
}
    //need this for hashable to make dictionary
func ==(lhs: FlashcardModel, rhs: FlashcardModel) -> Bool {
    return lhs.term == rhs.term && lhs.definition == rhs.definition
}
