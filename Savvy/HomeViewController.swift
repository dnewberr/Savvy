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
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func viewBadges(sender: AnyObject) {
        performSegueWithIdentifier("homeToBadges", sender: sender)
    }
    @IBAction func createSet(sender: AnyObject) {
        let nextScene = self.storyboard?.instantiateViewControllerWithIdentifier("Create") as! CreateSetController
        nextScene.prevSceneId = "Home"
        presentViewController(nextScene, animated: false, completion: nil)
    }
    
    @IBAction func viewSets(sender: AnyObject) {
        performSegueWithIdentifier("viewSetsSegue", sender: sender)
    }
    
    @IBAction func importFromQuizlet(sender: AnyObject) {
        performSegueWithIdentifier("importFromQuizletSegue", sender: sender)
    }
    
    @IBAction func logOut(sender: AnyObject) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut() // this is an instance function
        
        print("User will now be logged out of Facebook.")
        
        performSegueWithIdentifier("homeToLogin", sender: sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        let nextScene = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
        presentViewController(nextScene!, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
