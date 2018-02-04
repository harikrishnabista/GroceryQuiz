//
//  Quiz.swift
//  MobileGrocery
//
//  Created by Hari Krishna Bista on 2/3/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class Quiz {
    var questions:[Question]
    var finalScore:Int = 0
    
    public static let TotalDurationInSeconds = 60.0
    
    var currentQuestion:Question!
    
    init(questions:[Question]) {
        self.questions = questions
        
        if questions.count > 0 {
            self.currentQuestion = questions[0]
        }
    }
    
    func getFinalScore() -> Int {
        var finalScore = 0
        
        for item in self.questions {
            if item.selected == item.rightAns {
                finalScore = finalScore + 1
            }
        }
        
        return finalScore
    }
    
    func getPrevQuestion() -> Question? {
        for (i,item) in self.questions.enumerated(){
            if item.questionTitle == self.currentQuestion.questionTitle, i > 0 {
                return self.questions[i - 1]
            }
        }
        return nil
    }
    
    func getNextQuestion() -> Question? {
        for (i,item) in self.questions.enumerated(){
            if item.questionTitle == currentQuestion.questionTitle, i + 1 < self.questions.count {
                return self.questions[i + 1]
            }
        }
        return nil
    }
    
    func getCurrentQuestionNumber() -> String {
        var currentQnsNum = 0
        
        for item in self.questions {
            if item.questionTitle == currentQuestion.questionTitle {
                break
            }
            currentQnsNum = currentQnsNum + 1
        }
        
        return "\(currentQnsNum + 1)/\(questions.count)"
    }
    
    func resetQuiz(){
        for item in questions{
            item.selected = nil
        }
        self.shuffleQuestions()
    }
    
    func shuffleQuestions() {
        for i in 0...(self.questions.count - 1) {
            let randomIndex = Int(arc4random_uniform(UInt32(self.questions.count - 1)))
            
            // swapping each index item with randomIndex item
            let temp = self.questions[i]
            self.questions[i] = self.questions[randomIndex]
            self.questions[randomIndex] = temp
        }
       
        self.currentQuestion = self.questions[0]
    }
    
    func getCorrectPercentage() -> Int {
        let val = Double(self.getFinalScore()) * 100.0/Double(self.questions.count)
        return Int(val)
    }
    
    func getQuizSummary() -> QuizSummary {
        let summary = QuizSummary()
        summary.totalQuestionMessage = "Total questions: \(self.questions.count)"
        summary.totalCorrectMessage = "Total correct answers: \(self.getFinalScore())"
        summary.percentageMessage = "Percentage correct answers: \( self.getCorrectPercentage()) %"
        
        return summary
    }
}
