//
//  CreateSetController.swift
//  Savvy
//
//  Created by Deborah Newberry on 2/9/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit

class CreateSetController: UIViewController {
    var cardsToCreate: Int!
    var cardSetName: String!
    var setDueDate: NSDate?
    var prevSceneId: String!
    var user: UserModel?
    var flashcardsList: [FlashcardModel]?
    
    @IBOutlet weak var numCardsTextField: UITextField!
    @IBOutlet weak var setNameTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    @IBOutlet weak var dateSwitch: UISwitch!
    @IBAction func switchChange(sender: AnyObject) {
         dueDatePicker.hidden = !dueDatePicker.hidden
    }
    
    // Allows unwinding to createSet
    @IBAction func unwindToCreateSetViewController(segue: UIStoryboardSegue) {}
    
    @IBOutlet weak var doneButton: UIButton!
    @IBAction func donePushedAction(sender: AnyObject) {
        if checkInput() {
            let alertController = UIAlertController(title: "",
                message: "Save these changes?",
                preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            alertController.addAction(
                UIAlertAction(title: "Yes",
                    style: UIAlertActionStyle.Default,
                    handler: { (action: UIAlertAction!) in
                        if self.prevSceneId == "Home" {
                            self.performSegueWithIdentifier("createSetToHome", sender: sender)
                        }
                        else if self.prevSceneId == "View" {
                            self.performSegueWithIdentifier("createSetToViewSets", sender: sender)
                        }
                }))
            
            alertController.addAction(
                UIAlertAction(title: "No",
                    style: UIAlertActionStyle.Default,
                    handler: nil))
            
            self.presentViewController(alertController,
                animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelPushedAction(sender: AnyObject) {
        let alertController = UIAlertController(title: "",
            message: "Are you sure you want to cancel these changes?",
            preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alertController.addAction(
            UIAlertAction(title: "Yes",
                style: UIAlertActionStyle.Destructive,
                handler: { (action: UIAlertAction!) in
                    if self.prevSceneId == "Home" {
                        self.performSegueWithIdentifier("createSetToHome", sender: sender)
                    }
                    else if self.prevSceneId == "View" {
                        self.performSegueWithIdentifier("createSetToViewSets", sender: sender)
                    }
            }))
        
        alertController.addAction(
            UIAlertAction(title: "No",
                style: UIAlertActionStyle.Default,
                handler: nil))
        
        self.presentViewController(alertController,
            animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dueDatePicker.hidden = true
    }
    
    func checkInput() -> Bool {
        if let numCards = numCardsTextField.text {
            let numCards = Int(numCards)
            if numCards != nil && numCards > 0 {
                cardsToCreate = numCards
            } else {
                let alertController = UIAlertController(title: "",
                    message: "The number of cards must be a natural number greater than 0 (ie, 1, 2, 3, ...).",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                alertController.addAction(
                    UIAlertAction(title: "Dismiss",
                        style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController,
                    animated: true, completion: nil)
                
                return false
            }
        }
        
        
        if let setName = setNameTextField.text {
            if setName.isEmpty {
                let alertController = UIAlertController(title: "",
                    message: "Please enter a name for the set.",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                alertController.addAction(
                    UIAlertAction(title: "Dismiss",
                        style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController,
                    animated: true, completion: nil)

                return false
            } else {
            // check to see if it already exist; if so => warning
            // return false
            // print("name already exists; want to overwrite?")
            
            // else
            
                cardSetName = setName
            }
        }
        if !dueDatePicker.hidden {
            setDueDate = dueDatePicker.date
        }
        
        return true
    }
    
    func checkFlashcardListSize() {
        if flashcardsList == nil {
            flashcardsList = [FlashcardModel]()
            for _ in 1...cardsToCreate {
                flashcardsList?.append(FlashcardModel())
            }
        }
        else {
            if let count = flashcardsList?.count {
                if count < cardsToCreate {
                    for _ in 1...(cardsToCreate - count) {
                        flashcardsList?.append(FlashcardModel())
                    }
                }
                else if count > cardsToCreate {
                    for _ in 1...(count - cardsToCreate) {
                        flashcardsList?.removeLast()
                    }
                }
            }
        }
    }
    
    // Checks the inputs before using the segue, stops if inputs are not correct
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "createSetToEditCards" {
            return checkInput()
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createSetToEditCards" {
            let dest = segue.destinationViewController as! EditCardsViewController
            dest.cardsToCreate = cardsToCreate
            dest.cardSetName = cardSetName
            dest.setDueDate = setDueDate
            checkFlashcardListSize()
            dest.flashcardsList = [FlashcardModel]()
            for card in flashcardsList! {
                dest.flashcardsList.append(FlashcardModel(newTerm: card.term, newDef: card.definition, newDue: card.due))
            }
        }
    }
}