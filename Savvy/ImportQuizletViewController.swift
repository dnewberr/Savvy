//
//  ImportQuizletViewController.swift
//  Savvy
//
//  Created by Cody Rhoads on 2/9/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit

class ImportQuizletViewController: UIViewController {
    
    func authenticateQuizlet() {
        let authURL = "https://quizlet.com/authorize?response_type=code&client_id=kCdX95Dr9F&scope=read&state=NewberryRhoad"
        if let url = NSURL(string: authURL) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In ImportQuizletViewController")
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

