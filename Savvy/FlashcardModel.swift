//
//  Flashcard.swift
//  Savvy
//
//  Created by Cody Rhoads on 2/9/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import Foundation

class FlashcardModel {
    var term : String
    var definition : String
    var due : Int?
    var termSide: Bool!
    
    init() {
        term = ""
        definition = ""
        due = nil
        termSide = true
    }
    
    init(newTerm : String, newDef : String, newDue : Int?) {
        term = newTerm
        definition = newDef
        due = newDue
        termSide = true
    }
}