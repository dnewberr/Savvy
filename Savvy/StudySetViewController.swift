//
//  StudySetViewController.swift
//  Savvy
//
//  Created by Cody Rhoads on 2/11/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit
import GameplayKit

class StudySetViewController: UIViewController {
    @IBOutlet weak var setNameLabel: UILabel!
    var curSet: String!
    var user: UserModel!
    var flashcards: [FlashcardModel]!
    var curIndex: Int!
    var showTerms: Bool!
    @IBOutlet weak var curCard: UITextView!
    
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
    // Allows unwinding to study sets
    @IBAction func unwindToStudySetsViewController(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNameLabel.text = curSet
        // Randomizes order of flashcards
        flashcards = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(user.getCardsForSet(curSet)) as! [FlashcardModel]
        curIndex = 0
        curCard.text = flashcards[curIndex].term
    }
    
    @IBAction func tappedCard(sender: UITapGestureRecognizer) {
        let card = flashcards[curIndex]
        if card.termSide {
            curCard.text = card.definition
            card.termSide = false
        }
        else {
            curCard.text = card.term
            card.termSide = true
        }
    }
    
    @IBAction func swipedCard(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.Right:
            if curIndex == 0 {
                curIndex = flashcards.count - 1
            }
            else {
                curIndex = curIndex - 1
            }
        case UISwipeGestureRecognizerDirection.Left:
            if curIndex == flashcards.count - 1 {
                curIndex = 0
            }
            else {
                curIndex = curIndex + 1
            }
        default:
            break
        }
        
        curCard.text = flashcards[curIndex].term
        flashcards[curIndex].termSide = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "studyToGame" {
            let dest = segue.destinationViewController as! GameViewController
            dest.curSet = curSet
            //dest.user = user
            dest.flashcards = flashcards
            dest.showTerms = showTerms
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
