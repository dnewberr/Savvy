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
    var prevScene: UIViewController!
    var prevSceneId: String!
    
    @IBOutlet weak var numCardsTextField: UITextField!
    @IBOutlet weak var setNameTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    @IBOutlet weak var dateSwitch: UISwitch!
    @IBAction func switchChange(sender: AnyObject) {
         dueDatePicker.hidden = !dueDatePicker.hidden
    }
    
    @IBAction func editCardsPushedAction(sender: AnyObject) {
        if checkInput() {
            let nextScene = self.storyboard!.instantiateViewControllerWithIdentifier("EditCards") as! EditCardsViewController
            nextScene.cardsToCreate = cardsToCreate
            nextScene.cardSetName = cardSetName
            nextScene.setDueDate = setDueDate
            nextScene.prevSceneId = prevSceneId
            presentViewController(nextScene, animated: false, completion: nil)
        }
    }
    
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
                        self.presentViewController(self.prevScene, animated: false, completion: nil)
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
                    self.presentViewController(self.prevScene, animated: false, completion: nil)
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
        //print("Now in create set.")
        
        if prevSceneId == "View" {
            prevScene = self.storyboard!.instantiateViewControllerWithIdentifier(prevSceneId) as! ViewSetsViewController
        } else {
            prevScene = self.storyboard!.instantiateViewControllerWithIdentifier(prevSceneId) as! HomeViewController
        }
        
        
        dueDatePicker.hidden = true
    }
    
    func checkInput() -> Bool {
        if let numCards = numCardsTextField.text {
            let numCards = Int(numCards)
            if numCards != nil && numCards > 0 {
                cardsToCreate = numCards
            } else {
                //show alert
                let alertController = UIAlertController(title: "",
                    message: "The number of cards must be a natural number greater than 0 (ie, 1, 2, 3, ...).",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                alertController.addAction(
                    UIAlertAction(title: "Dismiss",
                        style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController,
                    animated: true, completion: nil)
                
                //print("num cards must be an int")
                
                return false
            }
        }
        
        
        if let setName = setNameTextField.text {
            if setName.isEmpty {
                // show alert
                let alertController = UIAlertController(title: "",
                    message: "Please enter a name for the set.",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                alertController.addAction(
                    UIAlertAction(title: "Dismiss",
                        style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController,
                    animated: true, completion: nil)
                //print("didn't set the name")
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
            //print("Date selected: \(setDueDate!)")
        }
        
        //print("Will create \(cardsToCreate) cards for set \(cardSetName)")

        
        return true
    }
}