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
    
    @IBOutlet weak var numCardsTextField: UITextField!
    @IBOutlet weak var setNameTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    @IBOutlet weak var dateSwitch: UISwitch!
    @IBAction func switchChange(sender: AnyObject) {
         dueDatePicker.hidden = !dueDatePicker.hidden
    }
    
    @IBOutlet weak var editCardsButton: UIButton!
    @IBAction func editCardsPushedAction(sender: AnyObject) {
        if checkInput() {
            let nextScene = self.storyboard!.instantiateViewControllerWithIdentifier("EditCards") as! EditCardsViewController
            nextScene.cardsToCreate = cardsToCreate
            nextScene.cardSetName = cardSetName
            nextScene.setDueDate = setDueDate
            presentViewController(nextScene, animated: false, completion: nil)
        }
    }
    
    @IBOutlet weak var doneButton: UIButton!
    @IBAction func donePushedAction(sender: AnyObject) {
        if checkInput() {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Now in create set.")
        dueDatePicker.hidden = true
    }
    
    func checkInput() -> Bool {
        if let numCards = numCardsTextField.text {
            if Int(numCards) != nil {
                cardsToCreate = Int(numCards)
            
            } else {
                //show alert
                print("num cards must be an int")
                return false
            }
        } else {
            // show alert
            print("didn't set num cards")
            return false
        }
        
        
        if let setName = setNameTextField.text {
            // check to see if it already exist; if so => warning
            // return false
            // print("name already exists; want to overwrite?")
            
            // else
            
            cardSetName = setName
        } else {
            // show alert
            print("didn't set the name")
            return false
        }
        
        if !dueDatePicker.hidden {
            setDueDate = dueDatePicker.date
            print("Date selected: \(setDueDate!)")
        }
        
        print("Will create \(cardsToCreate) cards for set \(cardSetName)")

        
        return true
    }
}