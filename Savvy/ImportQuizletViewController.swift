//
//  ImportQuizletViewController.swift
//  Savvy
//
//  Created by Cody Rhoads on 2/9/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit
import Alamofire

class ImportQuizletViewController: UIViewController {
    
    func authenticateQuizlet() {
        if !QuizletAPIManager.sharedInstance.hasOAuthToken() {
            QuizletAPIManager.sharedInstance.OAuthTokenCompletionHandler = {
                (error) -> Void in
                if let receivedError = error {
                    print(receivedError)
                    QuizletAPIManager.sharedInstance.startOAuth2Login()
                }
                else {
                    let path = "https://api.quizlet.com/2.0/users/\(QuizletAPIManager.sharedInstance.userID!)/sets"
                    print(path)
                    
                    // I believe I have to make the .GET call here, using the defined path
                    // and the token in QuizletAPIManager.sharedInstance.OAuthToken
                    
                    
                    // Code that doesn't work
                    
//                    var manager = Alamofire.Manager.sharedInstance
//                    
//                    manager.session.configuration.HTTPAdditionalHeaders = ["Authorization": "Bearer \(QuizletAPIManager.sharedInstance.OAuthToken!)"]
//                    print(manager.session.configuration.HTTPAdditionalHeaders!["Authorization"])
//                    manager.request(.GET, path).response { (request, response, data, error) -> Void in
//                        print("DATA: \(data)")
//                    }
                }
            }
            QuizletAPIManager.sharedInstance.startOAuth2Login()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In ImportQuizletViewController")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        authenticateQuizlet()
    }
    
    @IBAction func doneButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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