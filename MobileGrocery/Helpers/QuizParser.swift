//
//  QuizParser.swift
//  MobileGrocery
//
//  Created by Hari Krishna Bista on 2/3/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class QuizParser: NSObject {
    func parseQuiz(data:Data?,resp:URLResponse?,err:Error?) -> Quiz? {
        
        if let err = err {
            print(err.localizedDescription)
            return nil
        }
        
        guard let data = data else {
            return nil
        }
        
        do{
            
            if let questionsJson = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                
                var questions:[Question] = []
                
                for key in questionsJson.allKeys {
                    if let qnsTitle = key as? String, let ansColl:[String] = questionsJson[key] as? [String] {
                        questions.append(Question(questionTitle: qnsTitle, answers: ansColl))
                    }
                }
                
                return Quiz(questions: questions)
            }
            
        } catch {
            print("Json parsing error");
        }
        
        return nil
    }
}
