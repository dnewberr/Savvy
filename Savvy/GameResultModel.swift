//
//  GameResultModel.swift
//  Savvy
//
//  Created by Deborah Newberry on 3/15/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import Foundation

public class GameResultModel {
    static func getWrongAnswers(checkTerms: Bool, var flashcards: [FlashcardModel], var answers: [FlashcardModel]) -> [FlashcardModel: FlashcardModel] {
        var wrongAnswers: [FlashcardModel: FlashcardModel] = [:]
        print("answers = \(answers.count)  | versus | \(flashcards.count) = flashcards")
        print(answers)
        for i in 0...(answers.count - 1) {
            if flashcards[i] != answers[i] {
                    wrongAnswers[flashcards[i]] = answers[i]
            }
        }
        
        return wrongAnswers
    }
    
    static func calculateScore(total: Int, wrong: Int) -> Double {
        return (Double(total - wrong) / Double(total)) * 100
    }
}