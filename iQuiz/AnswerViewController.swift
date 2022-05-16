//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Chuteng Li on 2022/5/16.
//

import UIKit

class AnswerViewController: UIViewController {
    @IBOutlet weak var answerText: UILabel!
    
    var answer: String!
    var question: String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        answerText.text = "the correct answer of \n \(question!) is \n \(answer!)"
    }
    
    @IBAction func dissmissPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
