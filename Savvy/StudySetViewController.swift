//
//  StudySetViewController.swift
//  Savvy
//
//  Created by Cody Rhoads on 2/11/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit

class StudySetViewController: UIViewController {
    @IBOutlet weak var setNameLabel: UILabel!
    var curSet: String!
    
    // Allows unwinding to study sets
    @IBAction func unwindToStudySetsViewController(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNameLabel.text = curSet
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "studyToGame" {
            let dest = segue.destinationViewController as! GameViewController
            //dest.setNameLabel.text = setNameLabel.text
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
