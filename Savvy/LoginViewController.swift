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
    
    // Allows unwinding to login
    @IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageName = "background"
        self.view?.backgroundColor = UIColor(patternImage: UIImage(named: imageName)!)    }
    
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            print("User was successfully logged in to Facebook.")
            reviewOrHomeScene()
        }
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
}

