//
//  Question.swift
//  MobileGrocery
//
//  Created by Hari Krishna Bista on 2/3/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class Question {
    var questionTitle:String
    var answers:[String]
    
    var rightAns:String
    var selected:String?
    var result:Bool = false
    
    init(questionTitle:String, answers:[String]) {
        self.questionTitle = questionTitle
        self.answers = answers
        
        self.rightAns = self.answers[0]
        
        shuffle()
    }

    func shuffle() {
        for i in 0...(self.answers.count - 1) {
            //swap
            let randomIndex = self.getRandomIndex()
            let temp = self.answers[i]
            self.answers[i] = self.answers[randomIndex]
            self.answers[randomIndex] = temp
        }
    }
    
    func getRandomIndex() -> Int {
        return Int(arc4random_uniform(UInt32(self.answers.count - 1)))
    }
}
