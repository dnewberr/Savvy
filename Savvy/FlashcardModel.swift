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
    // random hashValue to comply with Hashable
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
        return lhs.trimLowerCase() == self.term.trimLowerCase()
    }
    
    func equalDefs(lhs: String) -> Bool {
        return lhs.trimLowerCase() == self.definition.trimLowerCase()
    }
}
    //need this for hashable to make dictionary
func ==(lhs: FlashcardModel, rhs: FlashcardModel) -> Bool {
    return lhs.term.trimLowerCase() == rhs.term.trimLowerCase() && lhs.definition.trimLowerCase() == rhs.definition.trimLowerCase()
}

extension String
{
    func trimLowerCase() -> String
    {
        return self.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}
