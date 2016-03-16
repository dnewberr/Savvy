//
//  ResultViewController.swift
//  Savvy
//
//  Created by Deborah Newberry on 2/16/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit

class ResultTableCell: UITableViewCell {
    
    @IBOutlet weak var answerTermTextView: TermTextView!
    @IBOutlet weak var answerDefTextView: DefTextView!
    
    @IBOutlet weak var correctTermTextView: TermTextView!
    @IBOutlet weak var correctDefTextView: DefTextView!
}

class ResultViewController: UIViewController {
    @IBOutlet weak var setNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    var curSet: String!
    var answers: [FlashcardModel]!
    var flashcards: [FlashcardModel]!
    var wrongAnswers: [FlashcardModel: FlashcardModel]!
    var score: Double!
    var checkTerms: Bool!
    
    @IBOutlet weak var wrongCardsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setNameLabel.text = curSet
        wrongAnswers = GameResultModel.getWrongAnswers(checkTerms, flashcards: flashcards, answers: answers)
        score = GameResultModel.calculateScore(flashcards.count, wrong: wrongAnswers.keys.count)

        scoreLabel.text = "SCORE: \(score)%"
        print("\(score)%")
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wrongAnswers.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = wrongCardsTable.dequeueReusableCellWithIdentifier("wrongAnswerCell") as! ResultTableCell
        
        let correct = Array(wrongAnswers.keys)[indexPath.row]
        let wrong = Array(wrongAnswers.values)[indexPath.row]
        print("CORRECT: " + correct.term + " = " + correct.definition)
        print("WRONG: " + wrong.term + " = " + wrong.definition)
        
        cell.answerTermTextView.text = wrong.term
        cell.answerDefTextView.text = wrong.definition
        cell.correctTermTextView.text = correct.term
        cell.correctDefTextView.text = correct.definition
        
        
        /*cell.termNameTextView.tag = indexPath.row
        cell.definitionTextView.tag = indexPath.row
        cell.termNameTextView.delegate = self
        cell.definitionTextView.delegate = self
        
        cell.definitionTextView.text = wrongAnswers[indexPath.row].definition*/
        
        return cell
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
}
