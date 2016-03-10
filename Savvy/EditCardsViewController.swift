//
//  EditCardsViewController.swift
//  Savvy
//
//  Created by Deborah Newberry on 2/16/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit

class EditTableViewCell: UITableViewCell {
    @IBOutlet weak var definitionTextField: DefTextField!
    @IBOutlet weak var termNameTextField: TermTextField!
}

class DefTextField: UITextField {}
class TermTextField: UITextField {}

class EditCardsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var cardsToCreate: Int!
    var cardSetName: String!
    var setDueDate: NSDate?
    var flashcardsList: [FlashcardModel]!
    var saved = false
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editCardsTableView: UITableView!
 
    @IBAction func done(sender: AnyObject) {
        let alertController = UIAlertController(title: "",
            message: "Save these changes?",
            preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alertController.addAction(
            UIAlertAction(title: "Yes",
                style: UIAlertActionStyle.Default,
                handler: { [unowned self] (action: UIAlertAction!) in
                    self.saved = true
                    self.performSegueWithIdentifier("editCardsToCreateSet", sender: sender)
            }))
        
        alertController.addAction(
            UIAlertAction(title: "No",
                style: UIAlertActionStyle.Default,
                handler: nil))
        
        self.presentViewController(alertController,
            animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        let alertController = UIAlertController(title: "",
            message: "Are you sure you want to cancel these changes?",
            preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alertController.addAction(
            UIAlertAction(title: "Yes",
                style: UIAlertActionStyle.Destructive,
                handler: { [unowned self] (action: UIAlertAction!) in
                    self.performSegueWithIdentifier("editCardsToCreateSet", sender: sender)
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
        nameLabel.text? = cardSetName
        
        //self.editCardsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "editCell")
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardsToCreate;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = editCardsTableView.dequeueReusableCellWithIdentifier("editCell") as! EditTableViewCell
        
        // Used to keep track of index path when saving edits
        cell.termNameTextField.tag = indexPath.row
        cell.definitionTextField.tag = indexPath.row
        
        cell.termNameTextField.delegate = self
        cell.definitionTextField.delegate = self
        
        return cell
    }
    
    // Displays the information of the corresponding flashcard
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell = cell as! EditTableViewCell
    
        cell.termNameTextField.text = flashcardsList[indexPath.row].term
        cell.definitionTextField.text = flashcardsList[indexPath.row].definition
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField is TermTextField {
            flashcardsList[textField.tag].term = textField.text!
        }
        else if textField is DefTextField {
            flashcardsList[textField.tag].definition = textField.text!
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
    
    /*func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        print("You selected cell #\(indexPath.row)!")
    }*/

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editCardsToCreateSet" && saved {
            let dest = segue.destinationViewController as! CreateSetController
            dest.flashcardsList = flashcardsList
        }
    }
}
