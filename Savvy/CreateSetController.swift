//
//  CreateSetController.swift
//  Savvy
//
//  Created by Deborah Newberry on 2/9/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit
import Parse

class CreateSetController: UIViewController, UITextFieldDelegate {
    var cardSetName: String!
    var prevSceneId: String!
    var user: UserModel!
    var flashcardsList: [FlashcardModel]?
    
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
                    handler: { [unowned self] (action: UIAlertAction!) in
                        self.saveToParse()
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
                handler: { [unowned self] (action: UIAlertAction!) in
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
        setNameTextField.delegate = self
        
        if cardSetName != nil {
            setNameTextField.text = cardSetName
        }
    }
    
    func checkInput() -> Bool {
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
        
        return true
    }
    
    func saveToParse() {
        // Making sure we don't have duplicate sets
        let query = PFQuery(className: "Set")
        query.whereKey("username", equalTo: user.username)
        query.whereKey("set", equalTo: cardSetName)
        query.findObjectsInBackgroundWithBlock { [weak self] (objects, error) -> Void in
            if error == nil {
                if let actualSelf = self, objects = objects {
                    if objects.count == 0 {
                        // No objects, so save it to Parse.
                        let setObject = PFObject(className: "Set")
                        setObject["username"] = actualSelf.user.username
                        setObject["set"] = actualSelf.cardSetName
                        if !actualSelf.dueDatePicker.hidden {
                            setObject["dueDate"] = actualSelf.dueDatePicker.date
                        }
                        else {
                            setObject["dueDate"] = NSDate.distantFuture()
                        }
                        setObject.saveInBackground()
                    }
                    else {
                        // The set is already there, so just update the due date.
                        if !actualSelf.dueDatePicker.hidden {
                            objects[0]["dueDate"] = actualSelf.dueDatePicker.date
                        }
                        else {
                            objects[0]["dueDate"] = NSDate.distantFuture()
                        }
                        objects[0].saveInBackground()
                    }
                    
                    for card in actualSelf.flashcardsList! {
                        // Finding the card in Parse to make sure we don't have duplicates.
                        let query = PFQuery(className: "Flashcard")
                        query.whereKey("username", equalTo: actualSelf.user.username)
                        query.whereKey("set", equalTo: actualSelf.cardSetName)
                        query.whereKey("term", equalTo: card.term)
                        query.findObjectsInBackgroundWithBlock() { (objects, error) -> Void in
                            if error == nil {
                                if let objects = objects {
                                    if objects.count == 0 {
                                        // No objects, so save it to Parse.
                                        let cardObject = PFObject(className: "Flashcard")
                                        cardObject["username"] = actualSelf.user.username
                                        cardObject["set"] = actualSelf.cardSetName
                                        cardObject["term"] = card.term
                                        cardObject["definition"] = card.definition
                                        cardObject.saveInBackground()
                                    }
                                    else {
                                        // There is already an object, so update the definition
                                        objects[0]["definition"] = card.definition
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
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
            dest.cardSetName = cardSetName
            
            if flashcardsList == nil {
                flashcardsList = [FlashcardModel.init()]
            }
            dest.flashcardsList = [FlashcardModel]()
            for card in flashcardsList! {
                dest.flashcardsList.append(FlashcardModel(newTerm: card.term, newDef: card.definition))
            }
        }
    }
}