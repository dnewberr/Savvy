//
//  ViewSetsViewController.swift
//  Savvy
//
//  Created by Cody Rhoads on 2/9/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit
import Parse

class ViewSetsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var pickerData: [String]!
    var user: UserModel!
    
    @IBOutlet weak var setPicker: UIPickerView!
    
    // Allows unwinding to view sets
    @IBAction func unwindToViewSetsViewController(segue: UIStoryboardSegue) {
        pickerData = user.getSets()
        for data in pickerData {
            print(data)
        }
        setPicker.reloadAllComponents()
        print("Now I'm angry!")
    }
    
    override func viewDidLoad() {
        setPicker.dataSource = self
        setPicker.delegate = self
        
        pickerData = user.getSets()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewSetsToCreateSet" {
            let dest = segue.destinationViewController as! CreateSetController
            let set = pickerData[setPicker.selectedRowInComponent(0)]
            dest.user = user
            dest.prevSceneId = "View"
            dest.cardSetName = set
            dest.flashcardsList = user.getCardsForSet(set)
        }
        
        if segue.identifier == "viewSetsToStudy" {
            let dest = segue.destinationViewController as! StudySetViewController
            dest.curSet = pickerData[setPicker.selectedRowInComponent(0)]
            dest.user = user
        }
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //myLabel.text = pickerData[row]
    }
}
