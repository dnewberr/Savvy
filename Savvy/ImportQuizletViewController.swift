//
//  ImportQuizletViewController.swift
//  Savvy
//
//  Created by Cody Rhoads on 2/9/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit
import Alamofire
import Parse

class ImportQuizletViewController: UIViewController {
    var user: UserModel!
    
    func authenticateQuizlet() {
        if !QuizletAPIManager.sharedInstance.hasOAuthToken() {
            QuizletAPIManager.sharedInstance.OAuthTokenCompletionHandler = {
                [unowned self] (error) -> Void in
                if let receivedError = error {
                    print(receivedError)
                    QuizletAPIManager.sharedInstance.startOAuth2Login()
                }
                else {
                    self.importFromQuizlet()
                }
            }
            QuizletAPIManager.sharedInstance.startOAuth2Login()
        }
        else {
            importFromQuizlet()
        }
    }
    
    func importFromQuizlet() {
        let path = "https://api.quizlet.com/2.0/users/\(QuizletAPIManager.sharedInstance.userID!)/sets"
        let headers = ["Authorization": "Bearer \(QuizletAPIManager.sharedInstance.OAuthToken!)"]
        
        Alamofire.request(.GET, path, headers: headers)
            .response { [unowned self] (request, response, data, error) in
                if let data = data {
                    let json = JSON(data: data)
                    
                    for (_, set) in json {
                        self.user.saveToParseFromQuizlet(set["title"].stringValue, cardsInSet: set["terms"])
                    }
                    
                    self.user.saveBadgeToParse("BEST BADGE YOU'VE EVER RECEIVED")
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        authenticateQuizlet()
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