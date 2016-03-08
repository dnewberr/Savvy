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
    
    func authenticateQuizlet() {
        if !QuizletAPIManager.sharedInstance.hasOAuthToken() {
            QuizletAPIManager.sharedInstance.OAuthTokenCompletionHandler = {
                (error) -> Void in
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
            .response { (request, response, data, error) in
                if let data = data {
                    let json = JSON(data: data)
                    print(json)
                    
                    for (_, set) in json {
                        let username = set["creator"]["username"].stringValue
                        let setName = set["title"].stringValue
                        
                        // Finding the set in Parse to make sure we don't have duplicates.
                        let query = PFQuery(className: "Set")
                        query.whereKey("username", equalTo: username)
                        query.whereKey("set", equalTo: setName)
                        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                            if error == nil {
                                if let objects = objects {
                                    if objects.count == 0 {
                                        // No objects, so save it to Parse.
                                        let setObject = PFObject(className: "Set")
                                        setObject["username"] = username
                                        setObject["set"] = setName
                                        setObject.saveInBackgroundWithBlock { (success, error) -> Void in
                                            print("Set \(set["title"].stringValue) is saved")
                                        }
                                    }
                                    for (_, card) in set["terms"] {
                                        // Finding the card in Parse to make sure we don't have duplicates.
                                        let query = PFQuery(className: "Flashcard")
                                        query.whereKey("username", equalTo: username)
                                        query.whereKey("set", equalTo: setName)
                                        query.whereKey("term", equalTo: card["term"].stringValue)
                                        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                                            if error == nil {
                                                if let objects = objects {
                                                    if objects.count == 0 {
                                                        // No objects, so save it to Parse.
                                                        let cardObject = PFObject(className: "Flashcard")
                                                        cardObject["username"] = username
                                                        cardObject["set"] = setName
                                                        cardObject["term"] = card["term"].stringValue
                                                        cardObject["definition"] = card["definition"].stringValue
                                                        cardObject.saveInBackgroundWithBlock { (success, error) -> Void in
                                                            print("Card \(cardObject["term"]) is saved")
                                                        }
                                                    }
                                                    else {
                                                        // There is already an object, so update the definition
                                                        objects[0]["definition"] = card["definition"].stringValue
                                                        objects[0].saveInBackground()
                                                        print("Card \(objects[0]["term"]) is updated")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
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