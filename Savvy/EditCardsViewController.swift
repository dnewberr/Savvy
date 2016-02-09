//
//  EditCardsViewController.swift
//  Savvy
//
//  Created by Deborah Newberry on 2/9/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit

class EditCardsViewController: UIViewController {
    var cardsToCreate: Int!
    var cardSetName: String!
    var setDueDate: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Now edit cards: NAME [\(cardSetName)] NUM [\(cardsToCreate)]")
        
        if setDueDate != nil {
            print("Due date selected: \(setDueDate)")
        }
    }
}