//
//  HomeViewController.swift
//  Savvy
//
//  Created by Deborah Newberry on 2/2/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Parse

class CardCollectionViewCell: UICollectionViewCell {
    var flashcard: Flashcard?
    @IBOutlet weak var label: UILabel!
}

class HomeViewController: UIViewController, FBSDKLoginButtonDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // Collection of flashcards
    @IBOutlet weak var flashcardCollection: UICollectionView!
    
    // Array to hold flashcards
    var cardArray = Array<Flashcard>()
    
    // Allows unwinding to home
    @IBAction func unwindToHomeViewController(segue: UIStoryboardSegue) {}
    
//    @IBAction func logOut(sender: AnyObject) {
//        let loginManager = FBSDKLoginManager()
//        loginManager.logOut() // this is an instance function
//        
//        print("User will now be logged out of Facebook.")
//        
//        performSegueWithIdentifier("homeToLogin", sender: sender)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Populates array with flashcards for testing purposes
        for (var i = 0; i < 5; i++) {
            cardArray.append(Flashcard(newTerm: String(i), newDef: "The def is " + String(i * 2), newDue: 0))
        }
        setUpFlashcardCollection()
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Where we would presumably populate the flashcard array.
    func setUpFlashcardCollection() {
        flashcardCollection.dataSource = self
        flashcardCollection.delegate = self
    }
    
    // Returns how many cards are on the home screen (aka the length of the card array).
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    // Sets up the cells. The terms are shown initially.
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCell", forIndexPath: indexPath) as! CardCollectionViewCell
        let card = cardArray[indexPath.row]
        cell.flashcard = card
        if card.termSide == true {
            cell.label.text = card.term
        }
        else {
            cell.label.text = card.definition
        }
        return cell
    }

    // Switches between the term and definition when the flashcard is tapped.
    @IBAction func tappedCell(sender: AnyObject) {
        let tappedPoint = sender.locationInView(self.flashcardCollection)
        let tappedCellPath = flashcardCollection.indexPathForItemAtPoint(tappedPoint)
        if let tappedCellPath = tappedCellPath {
            let cell = flashcardCollection.cellForItemAtIndexPath(tappedCellPath) as! CardCollectionViewCell
            if let card = cell.flashcard {
                if card.termSide == true {
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "homeToCreateSet" {
            let dest = segue.destinationViewController as! CreateSetController
            dest.prevSceneId = "Home"
        }
        else if segue.identifier == "homeToLogin" {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut() // this is an instance function
            print("User will now be logged out of Facebook.")
        }
    }
}
