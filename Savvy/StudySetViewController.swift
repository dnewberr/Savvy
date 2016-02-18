//
//  StudySetViewController.swift
//  Savvy
//
//  Created by Cody Rhoads on 2/11/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit

class StudySetViewController: UIViewController {

    @IBAction func startGame(sender: AnyObject) {
        performSegueWithIdentifier("studyToGame", sender: sender)
    }
    
    @IBAction func backToView(sender: AnyObject) {
        performSegueWithIdentifier("studyToViewSets", sender: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
