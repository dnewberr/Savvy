//
//  Flashcard.swift
//  Savvy
//
//  Created by Cody Rhoads on 2/9/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import Foundation
import UIKit

class Flashcard : UIViewPrintFormatter {
    var term : String
    var definition : String
    var due : Int?
    var termSide: Bool!
    
    override init() {
        term = ""
        definition = ""
        due = nil
        termSide = true
        super.init()
    }
    
    init(newTerm : String, newDef : String, newDue : Int?) {
        term = newTerm
        definition = newDef
        due = newDue
        termSide = true
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        term = ""
        definition = ""
        due = nil
        termSide = true
        super.init()
    }
}