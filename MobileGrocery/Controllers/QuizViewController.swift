//
//  QuizViewController.swift
//  MobileGrocery
//
//  Created by Hari Krishna Bista on 2/3/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
//    var quiz:Quiz?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        print(self.quiz?.getFinalScore())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnStartQuizTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToQuestionContainer", sender: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        if segue.identifier == "segueToQuestionContainer" {
////            if let destinationViewCon = segue.destination as? QuestionContainerViewController, let quiz = quiz {
////                destinationViewCon.quiz = quiz
////            }
////        }
//    }
}
