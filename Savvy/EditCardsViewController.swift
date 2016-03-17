//
//  EditCardsViewController.swift
//  Savvy
//
//  Created by Deborah Newberry on 2/16/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit

class EditTableViewCell: UITableViewCell {
    @IBOutlet weak var termNameTextView: TermTextView!
    @IBOutlet weak var definitionTextView: DefTextView!
}

class DefTextView: UITextView {}
class TermTextView: UITextView {}

class EditCardsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    var cardSetName: String!
    var flashcardsList: [FlashcardModel]!
    var saved = false
    var activeField: UITextView?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editCardsTableView: UITableView!
 
    @IBAction func done(sender: AnyObject) {
        view.endEditing(true)
        if checkInput() {
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
    
    @IBAction func addCard(sender: AnyObject) {
        flashcardsList.append(FlashcardModel.init())
        let indexPath = [NSIndexPath(forRow: flashcardsList.count - 1, inSection: 0)]
        editCardsTableView.insertRowsAtIndexPaths(indexPath, withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func checkInput() -> Bool {
        for card in flashcardsList {
            if card.term == "" {
                let alertController = UIAlertController(title: "",
                    message: "Empty term in flashcard found. Please enter a term or remove the flashcard.",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                alertController.addAction(
                    UIAlertAction(title: "Dismiss",
                        style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                return false
            }
            else if card.definition == "" {
                let alertController = UIAlertController(title: "",
                    message: "Empty definition in flashcard found. Please enter a definition or remove the flashcard.",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                alertController.addAction(
                    UIAlertAction(title: "Dismiss",
                        style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                return false
            }
        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text? = cardSetName
        registerForKeyboardNotifications()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashcardsList.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = editCardsTableView.dequeueReusableCellWithIdentifier("editCell") as! EditTableViewCell
        
        // Used to keep track of index path when saving edits
        cell.termNameTextView.tag = indexPath.row
        cell.definitionTextView.tag = indexPath.row
        
        cell.termNameTextView.delegate = self
        cell.definitionTextView.delegate = self
        
        return cell
    }
    
    // Displays the information of the corresponding flashcard
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell = cell as! EditTableViewCell
    
        cell.termNameTextView.text = flashcardsList[indexPath.row].term
        cell.definitionTextView.text = flashcardsList[indexPath.row].definition
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let indexPathArr = [indexPath]
        flashcardsList.removeAtIndex(indexPath.row)
        editCardsTableView.deleteRowsAtIndexPaths(indexPathArr, withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.activeField = textView
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView is TermTextView {
            flashcardsList[textView.tag].term = textView.text!
        }
        else if textView is DefTextView {
            flashcardsList[textView.tag].definition = textView.text!
        }
        
        self.activeField = nil
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(aNotification: NSNotification) {
        let info = aNotification.userInfo as! [String: AnyObject],
        kbSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size,
        contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        
        self.editCardsTableView.contentInset = contentInsets
        self.editCardsTableView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height
        
        let pointInTable = activeField!.superview!.convertPoint(activeField!.frame.origin, toView: editCardsTableView)
        let rectInTable = activeField!.superview!.convertRect(activeField!.frame, toView: editCardsTableView)
        
        if !CGRectContainsPoint(aRect, pointInTable) {
            self.editCardsTableView.scrollRectToVisible(rectInTable, animated: true)
        }
    }
    
    func keyboardWillBeHidden(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero
        self.editCardsTableView.contentInset = contentInsets
        self.editCardsTableView.scrollIndicatorInsets = contentInsets
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }
    
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
