//
//  QuestionViewController.swift
//  MobileGrocery
//
//  Created by Hari Krishna Bista on 2/3/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var question:Question!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblQuestionTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblQuestionTitle.text = question.questionTitle
        collectionView.dataSource = self
        collectionView.delegate = self

    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.collectionView.reloadData()
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let parentContainerViewCon = self.parent?.parent as? QuestionContainerViewController {
            parentContainerViewCon.quiz.currentQuestion = self.question
            parentContainerViewCon.title = parentContainerViewCon.quiz.getCurrentQuestionNumber()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return question.answers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnswerCollectionViewCell", for: indexPath) as! AnswerCollectionViewCell
        
        let ansImgUrl = question.answers[indexPath.row]
        if let selected = question.selected, selected == ansImgUrl {
            cell.imgAnswer.layer.borderColor = UIColor.blue.cgColor
            cell.imgAnswer.layer.borderWidth = 1.0
            cell.imgAnswer.layer.cornerRadius = 3.0
            
            self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            
        }else{
            cell.imgAnswer.layer.borderColor = UIColor.clear.cgColor
        }

        if let cacheImage = GlobalCache.shared.imageCache[ansImgUrl] {
            DispatchQueue.main.async {
                cell.imgAnswer.image = cacheImage
            }
        }else{
            cell.imgAnswer.image = UIImage(named: "iconNoImage")
            
            if let imgUrl = URL(string:ansImgUrl) {
                ApiCaller().getImageFrom(url: imgUrl, completion: { (downloadedImage) in
                    if let downloadedImage = downloadedImage {
                        DispatchQueue.main.async {
                            GlobalCache.shared.imageCache[ansImgUrl] = downloadedImage
                            cell.imgAnswer.image = downloadedImage
                        }
                    }
                })
            }
        }
        
        cell.imgAnswer.image = UIImage(named: "iconNoImage")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        question.selected = question.answers[indexPath.row]
        
        if let cell = collectionView.cellForItem(at: indexPath) as? AnswerCollectionViewCell {
            cell.imgAnswer.layer.borderColor = UIColor.blue.cgColor
            cell.imgAnswer.layer.borderWidth = 1.0
            cell.imgAnswer.layer.cornerRadius = 3.0
        }
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
     
        let width = UIScreen.main.bounds.size.width
        
        return CGSize(width: width/2, height: width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? AnswerCollectionViewCell {
            cell.imgAnswer.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
