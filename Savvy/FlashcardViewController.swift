//
//  FlashcardViewController.swift
//  Savvy
//
//  Created by Deborah Newberry on 2/15/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit

class FlashcardViewController: UIViewController {
    var currentCard : FlashcardModel!
    var front = true
    
    @IBOutlet weak var currentView: UILabel!
    
    
    @IBAction func flipCard(sender: AnyObject) {
        if front {
            currentView.text = currentCard.definition
            front = false
        } else {
            currentView.text = currentCard.term
            front = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentView.text = currentCard.term
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
