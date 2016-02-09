//
//  HomeViewController.swift
//  Savvy
//
//  Created by Deborah Newberry on 2/2/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var createSetButton: UIButton!
    
    @IBAction func createSet(sender: AnyObject) {
        print("Touched button")
        let nextScene = self.storyboard?.instantiateViewControllerWithIdentifier("Create")
        presentViewController(nextScene!, animated: false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Now in home.")
    }
}
