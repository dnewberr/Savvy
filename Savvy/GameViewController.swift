//
//  GameViewController.swift
//  Savvy
//
//  Created by Deborah Newberry on 2/16/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var setNameLabel: UILabel!
    @IBAction func submitAnswers(sender: AnyObject) {
        performSegueWithIdentifier("gameToResult", sender: sender)
    }
    
    @IBAction func quit(sender: AnyObject) {
        // alert before returning to study
        performSegueWithIdentifier("gameToStudy", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gameToResult" {
            let dest = segue.destinationViewController as! GameViewController
            dest.setNameLabel.text = setNameLabel.text
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
