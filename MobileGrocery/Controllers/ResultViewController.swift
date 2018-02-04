//
//  ResultViewController.swift
//  MobileGrocery
//
//  Created by Hari Krishna Bista on 2/3/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    var quizSummary = QuizSummary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTotal.text = quizSummary.totalQuestionMessage
        lblCorrect.text = quizSummary.totalCorrectMessage
        lblPercentage.text = quizSummary.percentageMessage
        
        // Do any additional setup after loading the view.
    }

    @IBAction func btnDoneTapped(_ sender: Any) {
        self.dismiss(animated: true) {
        self.navigationController?.popToRootViewController(animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var lblCorrect: UILabel!
    
    @IBOutlet weak var lblPercentage: UILabel!

}
