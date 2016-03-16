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
    
    @IBOutlet weak var setNameLabel: UILabel!
    @IBOutlet weak var studyCardsTable: UITableView!
    
    // Allows unwinding to game
    @IBAction func unwindToGameViewController(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNameLabel.text = curSet
        
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
            answers.append(FlashcardModel(newTerm: flashcards[indexPath.row].term, newDef: ""))
        } else {
            cell.definitionTextView.text = flashcards[indexPath.row].definition
            cell.definitionTextView.editable = false
            cell.termNameTextView.editable = true
            answers.append(FlashcardModel(newTerm: "", newDef: flashcards[indexPath.row].definition))
        }
        
        return cell
    }

    func textViewDidEndEditing(textView: UITextView) {
        if showTerms.boolValue && !textView.text.isEmpty {
            let answer = answers.filter({$0.term == flashcards[textView.tag].term}).first
            answer?.definition = textView.text
            
        } else if !showTerms.boolValue && !textView.text.isEmpty {
            let answer = answers.filter({$0.definition == flashcards[textView.tag].definition}).first
            answer?.term = textView.text
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
}
