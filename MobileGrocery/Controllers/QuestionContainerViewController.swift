//
//  QuestionContainerViewController.swift
//  MobileGrocery
//
//  Created by Hari Krishna Bista on 2/3/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class QuestionContainerViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController?
    
    @IBOutlet weak var progressBar: UIProgressView!
    lazy var quiz = Quiz(questions: [])
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initQuiz()
        self.title = self.quiz.getCurrentQuestionNumber()
    }
    
    var timeCounter = 0.0
    
    func setTimer() {
        self.timeCounter = 0.0
        self.progressBar.setProgress(1.0, animated: true)
        self.timer.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,   selector: (#selector(QuestionContainerViewController.timeFinished)), userInfo: nil, repeats: true)
    }
    
    @objc func timeFinished() {
        timeCounter = timeCounter + 0.1
        if timeCounter >= Quiz.TotalDurationInSeconds {
            self.timer.invalidate()
            self.progressBar.setProgress(1.0, animated: true)
            self.quizEnded()
            return
        }
        
        let progressVal = 1 - timeCounter / Quiz.TotalDurationInSeconds;
        self.progressBar.setProgress(Float(progressVal), animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer.invalidate()
    }

    func initQuiz() {
        if let url = URL(string:Constants.QUIZ_API) {
            self.navigationController?.view.showLoading(message: "Loading Quiz...")
            ApiCaller().getDataFromUrl(url: url, completion: { (data, resp, err) in
                DispatchQueue.main.async {
                    self.navigationController?.view.hideLoading()
                    
                    if let quiz = QuizParser().parseQuiz(data: data, resp: resp, err: err) {
                        self.quiz = quiz
                        self.quiz.shuffleQuestions()
                        self.setUIForQuiz()
                        self.setTimer()
                    }
                }
            })
        }
    }
    
    func setUIForQuiz() {

        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        if let _ = self.storyboard, let firstViewCon = self.viewControllerForQuestion(qns: quiz.currentQuestion, storyboard: self.storyboard!){
            
            self.pageViewController?.setViewControllers([firstViewCon], direction: .forward, animated: false, completion: {done in })
            
            self.pageViewController?.dataSource = self
            
            self.addChildViewController(self.pageViewController!)
            self.view.addSubview((self.pageViewController?.view)!)
            
            self.pageViewController?.didMove(toParentViewController: self)
            
            pageViewController?.view.translatesAutoresizingMaskIntoConstraints = false
            
            if let top = pageViewController?.view.topAnchor.constraint(equalTo: self.view.topAnchor) {
                top.isActive = true
                top.constant = top.constant + 70
            }
            
            
            pageViewController?.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            
            pageViewController?.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
            
            if let bottom = pageViewController?.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor) {
                bottom.isActive = true
                bottom.constant = bottom.constant - 50
            }
        
        }
    }
    
    @IBAction func btnNavBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func viewControllerForQuestion(qns:Question, storyboard: UIStoryboard) -> QuestionViewController? {
        
        let qViewController = storyboard.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        
        qViewController.question = qns
        
        return qViewController
    }
    
    // MARK: - Page View Controller Data Source
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        return nil
//        var index = self.getCurrentIndex()
//        if (index == 0) || (index == NSNotFound) {
//            return nil
//        }
//
//        index -= 1
//
//        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        var index = self.getCurrentIndex()
//        if index == NSNotFound {
//            return nil
//        }
//
//        index += 1
//        if index == quiz.questions.count {
//            return nil
//        }
//
//        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
        return nil
    }
    
    @IBAction func btnPreviousTapped(_ sender: Any) {
        if let prevQns = self.quiz.getPrevQuestion(), let currPage = self.viewControllerForQuestion(qns: prevQns, storyboard: self.storyboard!) {
            
            pageViewController?.setViewControllers([currPage], direction: .reverse, animated: true, completion: nil)
        }

    }
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        
        guard self.quiz.currentQuestion.selected != nil else {
            showAlert(title: "Mobile Grocery", message: "Please select one")
            return
        }
        
        if let nextQns = self.quiz.getNextQuestion(){
            if let currPage = self.viewControllerForQuestion(qns: nextQns, storyboard: self.storyboard!) {
                pageViewController?.setViewControllers([currPage], direction: .forward, animated: true, completion: nil)
            }
        }else{
            self.quizEnded()
        }
    }
    
    func quizEnded() {
        if let resultViewCon = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {
            
            resultViewCon.quizSummary = self.quiz.getQuizSummary()
            
            self.navigationController?.present(resultViewCon, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnExitTapped(_ sender: Any) {
        self.showExitAlert()
    }
    
    @IBAction func btnResetTapped(_ sender: Any) {
        self.showResetAlert()
    }
    
    func showResetAlert() {
        let refreshAlert = UIAlertController(title: "Mobile Grocery", message: "Are you sure to exit playing?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.quiz.resetQuiz()
            
            if let currPage = self.viewControllerForQuestion(qns: self.quiz.currentQuestion, storyboard: self.storyboard!) {
                self.pageViewController?.setViewControllers([currPage], direction: .forward, animated: false, completion: nil)
            }
            self.setTimer()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func showExitAlert() {
        let refreshAlert = UIAlertController(title: "Mobile Grocery", message: "Are you sure to exit playing?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
