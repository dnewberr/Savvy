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
    
    @IBAction func studySet(sender: AnyObject) {
        print("Touched Study Set button")
        performSegueWithIdentifier("studySetSegue", sender: sender)
    }
    
    @IBAction func editSet(sender: AnyObject) {
        print("Touched Edit Set button")
        performSegueWithIdentifier("editSetSegue", sender: sender)
    }
}
