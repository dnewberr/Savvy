//
//  ViewSetsViewController.swift
//  Savvy
//
//  Created by Cody Rhoads on 2/9/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit

class ViewSetsViewController: UIViewController {
    
    // Allows unwinding to view sets
    @IBAction func unwindToViewSetsViewController(segue: UIStoryboardSegue) {}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewSetsToCreateSet" {
            let dest = segue.destinationViewController as! CreateSetController
            dest.prevSceneId = "View"
        }
    }
}
