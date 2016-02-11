//
//  HomeViewController.swift
//  Savvy
//
//  Created by Deborah Newberry on 2/2/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class HomeViewController: UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var createSetButton: UIButton!
    @IBOutlet weak var viewSetsButton: UIButton!
    @IBOutlet weak var importButton: UIButton!
    
    @IBOutlet weak var logoutButton: FBSDKLoginButton!
    
    @IBAction func createSet(sender: AnyObject) {
        print("Touched Create Set button")
        performSegueWithIdentifier("createSetSegue", sender: sender)
    }
    
    @IBAction func viewSets(sender: AnyObject) {
        print("Touched View Sets button")
        performSegueWithIdentifier("viewSetSegue", sender: sender)
    }
    
    @IBAction func importFromQuizlet(sender: AnyObject) {
        print("Touched Import from Quizlet button")
        performSegueWithIdentifier("importFromQuizletSegue", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Now in home.")
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("Logged out")
        let nextScene = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
        presentViewController(nextScene!, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
