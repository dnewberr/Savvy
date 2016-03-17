//
//  LoginViewController.swift
//  Savvy
//
//  Created by Deborah Newberry on 2/2/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    var user: UserModel!
    
    @IBOutlet weak var logo: UIImageView!
    
    // Allows unwinding to login
    @IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onProfileUpdated:", name:FBSDKProfileDidChangeNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            user = UserModel.init(username: FBSDKProfile.currentProfile().userID)
            reviewOrHomeScene()
        }
    }
    
    func onProfileUpdated(notification: NSNotification) {
        
    }
    
    
    func reviewOrHomeScene() {
        performSegueWithIdentifier("loginToHome", sender: nil)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!,
        didCompleteWithResult result: FBSDKLoginManagerLoginResult!,
        error: NSError!) {
            reviewOrHomeScene()
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loginToHome" {
            let dest = segue.destinationViewController as! HomeViewController
            dest.user = user
        }
    }
}

