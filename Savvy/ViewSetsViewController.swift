//
//  ViewSetsViewController.swift
//  Savvy
//
//  Created by Cody Rhoads on 2/9/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit

class ViewSetsViewController: UIViewController {
    
    @IBOutlet weak var studySetButton: UIButton!
    @IBOutlet weak var editSetButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    
    @IBAction func studySet(sender: AnyObject) {
        performSegueWithIdentifier("viewSetsToStudySet", sender: sender)
    }
    
    @IBAction func editSet(sender: AnyObject) {
        let nextScene = self.storyboard?.instantiateViewControllerWithIdentifier("Create") as! CreateSetController
        nextScene.prevSceneId = "View"
        presentViewController(nextScene, animated: false, completion: nil)
    }
    
    @IBAction func goHome(sender: AnyObject) {        
        performSegueWithIdentifier("viewSetsToHome", sender: sender)
    }
}
