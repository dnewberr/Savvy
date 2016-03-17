//
//  GameViewController.swift
//  Savvy
//
//  Created by Deborah Newberry on 2/16/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit
import GameplayKit


class GameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    var curSet: String!
    var flashcards: [FlashcardModel]!
    var answers: [FlashcardModel]! = []
    var showTerms: Bool!
    var activeField: UITextView?
    
    @IBOutlet weak var setNameLabel: UILabel!
    @IBOutlet weak var studyCardsTable: UITableView!
    
    // Allows unwinding to game
    @IBAction func unwindToGameViewController(segue: UIStoryboardSegue) {
        registerForKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNameLabel.text = curSet
        registerForKeyboardNotifications()
        
        for i in 0...(flashcards.count - 1) {
            if showTerms.boolValue {
                answers.append(FlashcardModel(newTerm: flashcards[i].term, newDef: ""))
            } else {
                answers.append(FlashcardModel(newTerm: "", newDef: flashcards[i].definition))
            }
        }
        // Randomizes order of flashcards
        /*flashcards = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(user.getCardsForSet(curSet)) as! [FlashcardModel]*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gameToResult" {
            let dest = segue.destinationViewController as! ResultViewController
            
            dest.curSet = curSet
            dest.answers = answers
            dest.flashcards = flashcards
            dest.checkTerms = !showTerms
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashcards.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = studyCardsTable.dequeueReusableCellWithIdentifier("cardCell") as! EditTableViewCell
        cell.termNameTextView.tag = indexPath.row
        cell.definitionTextView.tag = indexPath.row
        cell.termNameTextView.delegate = self
        cell.definitionTextView.delegate = self
        
        if showTerms.boolValue {
            cell.termNameTextView.text = flashcards[indexPath.row].term
            cell.termNameTextView.editable = false
            cell.definitionTextView.editable = true
        } else {
            cell.definitionTextView.text = flashcards[indexPath.row].definition
            cell.definitionTextView.editable = false
            cell.termNameTextView.editable = true
        }
        
       
        return cell
    }

    func textViewDidEndEditing(textView: UITextView) {
        if showTerms.boolValue {
            let answer = answers.filter({$0.term == flashcards[textView.tag].term}).first
            answer?.definition = textView.text
            
        } else {
            let answer = answers.filter({$0.definition == flashcards[textView.tag].definition}).first
            answer?.term = textView.text
        }
        
        self.activeField = nil
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.activeField = textView
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(aNotification: NSNotification) {
        let info = aNotification.userInfo as! [String: AnyObject],
        kbSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size,
        contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        
        self.studyCardsTable.contentInset = contentInsets
        self.studyCardsTable.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height
        
        let pointInTable = activeField!.superview!.convertPoint(activeField!.frame.origin, toView: studyCardsTable)
        let rectInTable = activeField!.superview!.convertRect(activeField!.frame, toView: studyCardsTable)
        
        if !CGRectContainsPoint(aRect, pointInTable) {
            self.studyCardsTable.scrollRectToVisible(rectInTable, animated: true)
        }
    }
    
    func keyboardWillBeHidden(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero
        self.studyCardsTable.contentInset = contentInsets
        self.studyCardsTable.scrollIndicatorInsets = contentInsets
    }
    
    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
