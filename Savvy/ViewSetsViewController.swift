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
        //print("Touched Study Set button")
        
        performSegueWithIdentifier("viewSetsToStudySet", sender: sender)
    }
    
    @IBAction func editSet(sender: AnyObject) {
        //print("Touched Edit Set button")
        
        let nextScene = self.storyboard?.instantiateViewControllerWithIdentifier("Create") as! CreateSetController
        nextScene.prevSceneId = "View"
        presentViewController(nextScene, animated: false, completion: nil)
    }
    
    @IBAction func goHome(sender: AnyObject) {
        //print("Touched Home button")
        
        performSegueWithIdentifier("viewSetsToHome", sender: sender)
    }
}
