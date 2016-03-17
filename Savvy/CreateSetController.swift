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
    var dueDate: NSDate?
    var prevSetName: String!
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
                        let savingAlert = UIAlertController(title: "Saving...", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                        self.presentViewController(savingAlert, animated: true, completion: {
                            if self.prevSetName != nil && self.prevSetName != self.cardSetName {
                                self.user.deleteFromParse(self.prevSetName)
                            }
                            
                            if !self.dueDatePicker.hidden {
                                self.user.saveToParse(self.cardSetName, flashcards: self.flashcardsList!, dueDate: self.dueDatePicker.date)
                            }
                            else {
                                self.user.saveToParse(self.cardSetName, flashcards: self.flashcardsList!, dueDate: NSDate.distantFuture())
                            }
                            
                            if self.prevSceneId == "Home" {
                                self.performSegueWithIdentifier("createSetToHome", sender: sender)
                            }
                            else if self.prevSceneId == "View" {
                                self.performSegueWithIdentifier("createSetToViewSets", sender: sender)
                            }})
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
        setNameTextField.delegate = self
        
        setNameTextField.text = cardSetName
        if prevSceneId == "Home" {
            prevSetName = nil
        }
        else {
            prevSetName = cardSetName
        }
        
        if dueDate != nil && dueDate != NSDate.distantFuture() {
            dueDatePicker.hidden = false
            dueDatePicker.date = dueDate!
            dateSwitch.setOn(true, animated: false)
        }
        else {
            dueDatePicker.hidden = true
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
                cardSetName = setName
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }

    // Checks the inputs before using the segue, stops if inputs are not correct
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "createSetToEditCards" {
            return checkInput()
        }
        return true
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
            
            setNameTextField.resignFirstResponder()
        }
    }
}