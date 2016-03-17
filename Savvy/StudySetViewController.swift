//
//  StudySetViewController.swift
//  Savvy
//
//  Created by Cody Rhoads on 2/11/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit
import GameplayKit

class StudySetViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var setNameLabel: UILabel!
    var curSet: String!
    var user: UserModel!
    var flashcards: [FlashcardModel]!
    var showTerms: Bool!
    @IBOutlet weak var studyCollectionView: UICollectionView!
    
    @IBAction func startGame(sender: AnyObject) {
        let alertController = UIAlertController(title: "Start Game",
            message: "Do you want to start the game showing terms or definitions?",
            preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alertController.addAction(
            UIAlertAction(title: "Terms",
                style: UIAlertActionStyle.Default,
                handler: { [unowned self] (action: UIAlertAction!) in
                    self.showTerms = true
                    self.performSegueWithIdentifier("studyToGame", sender: sender)
        }))
        
        alertController.addAction(
            UIAlertAction(title: "Definitions",
                style: UIAlertActionStyle.Default,
                handler: { [unowned self] (action: UIAlertAction!) in
                    self.showTerms = false
                    self.performSegueWithIdentifier("studyToGame", sender: sender)
        }))
        
        alertController.addAction(
            UIAlertAction(title: "Cancel",
                style: UIAlertActionStyle.Destructive,
                handler: nil))
        
        self.presentViewController(alertController,
            animated: true, completion: nil)
    }
    
    @IBAction func help(sender: AnyObject) {
        let alertController = UIAlertController(title: "",
            message: "Tap the card to switch between terms and definitions. Swipe left or right to switch between cards in the set.",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(
            UIAlertAction(title: "Dismiss",
                style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Allows unwinding to study sets
    @IBAction func unwindToStudySetsViewController(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNameLabel.text = curSet
        
        // Randomizes order of flashcards
        flashcards = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(user.getCardsForSet(curSet)) as! [FlashcardModel]
    }
    
    // Returns how many cards are on the home screen (aka the length of the card array).
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flashcards.count
    }
    
    // Sets up the cells. The terms are shown initially.
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("studyCardCell", forIndexPath: indexPath) as! CardCollectionViewCell
        let card = flashcards[indexPath.row]
        cell.flashcard = card
        
        if card.termSide == true {
            cell.label.text = card.term
        }
        else {
            cell.label.text = card.definition
        }
        
        return cell
    }
    
    
    
    @IBAction func tappedCell(sender: AnyObject) {
        let tappedPoint = sender.locationInView(self.studyCollectionView)
        let tappedCellPath = studyCollectionView.indexPathForItemAtPoint(tappedPoint)
        if let tappedCellPath = tappedCellPath {
            let cell = studyCollectionView.cellForItemAtIndexPath(tappedCellPath) as! CardCollectionViewCell
            if let card = cell.flashcard {
                if card.termSide {
                    cell.label.text = card.definition
                    card.termSide = false
                }
                else {
                    cell.label.text = card.term
                    card.termSide = true
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "studyToGame" {
            let dest = segue.destinationViewController as! GameViewController
            
            dest.curSet = curSet
            dest.flashcards = flashcards
            dest.showTerms = showTerms
        }
    }
}
