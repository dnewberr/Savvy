//
//  EditCardsViewController.swift
//  Savvy
//
//  Created by Deborah Newberry on 2/16/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit

class EditCardsViewController: UIViewController {
    var cardsToCreate : Int!
    var cardSetName : String!
    var setDueDate : NSDate?
    var prevSceneId: String!
    var prevScene: UIViewController!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var table: EditCardsTableView!
    @IBAction func done(sender: AnyObject) {
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
    
    @IBAction func cancel(sender: AnyObject) {
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
        
        if prevSceneId == "View" {
            prevScene = self.storyboard!.instantiateViewControllerWithIdentifier(prevSceneId) as! ViewSetsViewController
        } else {
            prevScene = self.storyboard!.instantiateViewControllerWithIdentifier(prevSceneId) as! HomeViewController
        }
        
        table.cardsToCreate = self.cardsToCreate
        nameLabel.text? = cardSetName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embededToTable" {
            let newScene = segue.destinationViewController as! EditCardsTableViewController
            newScene.cardsToCreate = self.cardsToCreate
            performSegueWithIdentifier(segue.identifier!, sender: sender)
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }*/
    

}
