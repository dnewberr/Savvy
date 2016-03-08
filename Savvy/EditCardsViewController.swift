//
//  EditCardsViewController.swift
//  Savvy
//
//  Created by Deborah Newberry on 2/16/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit

class EditTableViewCell : UITableViewCell {
    
    @IBOutlet weak var definitionTextField: UITextField!
    @IBOutlet weak var termNameTextField: UITextField!
}

class EditCardsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var cardsToCreate : Int!
    var cardSetName : String!
    var setDueDate : NSDate?
    var prevSceneId: String!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editCardsTableView: UITableView!
 
    @IBAction func done(sender: AnyObject) {
        let alertController = UIAlertController(title: "",
            message: "Save these changes?",
            preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alertController.addAction(
            UIAlertAction(title: "Yes",
                style: UIAlertActionStyle.Default,
                handler: { (action: UIAlertAction!) in
                    self.performSegueWithIdentifier(self.prevSceneId, sender: sender)
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
                    self.performSegueWithIdentifier(self.prevSceneId, sender: sender)
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
        
        prevSceneId = prevSceneId == "View" ? "editCardsToViewSet" : "editCardsToHome"
        
        nameLabel.text? = cardSetName
        
        //self.editCardsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "editCell")
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardsToCreate;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = editCardsTableView.dequeueReusableCellWithIdentifier("editCell") as! EditTableViewCell
        
        
        return cell
    }
    
    /*func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        print("You selected cell #\(indexPath.row)!")
    }*/

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
