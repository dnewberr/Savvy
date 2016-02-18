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
                    let headers = ["Authorization": "Bearer \(QuizletAPIManager.sharedInstance.OAuthToken!)"]
                    
                    Alamofire.request(.GET, path, headers: headers)
                        .responseJSON { response in
                            print(response)
                    }
                }
            }
            QuizletAPIManager.sharedInstance.startOAuth2Login()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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