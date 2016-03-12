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
        editCardsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
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
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView is TermTextView {
            flashcardsList[textView.tag].term = textView.text!
        }
        else if textView is DefTextView {
            flashcardsList[textView.tag].definition = textView.text!
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
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
