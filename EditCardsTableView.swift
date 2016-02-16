//
//  EditCardsTableView.swift
//  Savvy
//
//  Created by Deborah Newberry on 2/16/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit

class FlashcardCell : UITableViewCell {
    
}

class EditCardsTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var cardsToCreate : Int!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardsToCreate
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FlashcardCell") as! FlashcardCell
        
        cell.textLabel?.text = "UGH"
        return cell
    }

}
