//
//  ResultViewController.swift
//  Savvy
//
//  Created by Deborah Newberry on 2/16/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    @IBAction func studySet(sender: AnyObject) {
        performSegueWithIdentifier("resultToStudy", sender: sender)
    }
    
    @IBAction func tryAgain(sender: AnyObject) {
         performSegueWithIdentifier("resultToGame", sender: sender)
    }
    
    @IBAction func goHome(sender: AnyObject) {
        performSegueWithIdentifier("resultToHome", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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