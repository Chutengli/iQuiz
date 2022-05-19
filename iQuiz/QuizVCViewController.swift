//
//  QuizVCViewController.swift
//  iQuiz
//
//  Created by Chuteng Li on 2022/5/15.
//

import UIKit

struct Answer {
    let text: String
    let corrent: Bool
}

class QuizVCViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var questionAnswers: UITableView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var category: String!
    var currentQuestion: Question!
    var currentAnswers: [Answer] = []
    
    var quizSet: [Question]!
    var score = 0
    var showedAnswer: Bool!
    var selectedIndex: Int!
    
    var questions: [Question]!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionAnswers.delegate = self
        questionAnswers.dataSource = self
        
        setupQuestion()
    }
    
    private func setupQuestion() {
        quizSet = questions
        let question = questions.first
        for i in stride(from: 0, through: (question?.answers!.count)! - 1, by: 1) {
            if (i + 1 == Int((question?.answer)!)) {
                currentAnswers.append(Answer(text: (question?.answers![i])!, corrent: true))
            } else {
                currentAnswers.append(Answer(text: (question?.answers![i])!, corrent: false))
            }
        }
        config(question: question!)
    }
    
    private func config(question: Question) {
        questionLabel.text = question.text
        currentQuestion = question
    }
    
    // Table view functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestion?.answers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quizCell", for: indexPath)
        cell.textLabel?.text = currentAnswers[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
    }
    
    @IBAction func moveToNext(_ sender: Any) {
        guard let question = currentQuestion else {
            return
        }
        
        if (selectedIndex != nil) {
            let answer = currentAnswers[selectedIndex]
            
            if (answer.corrent) {
                score += 1
            }
        }
                
        //show answer page
        performSegue(withIdentifier: "showAnswer", sender: self)
        nextQuestion(question: question)
        // check Answer
    }
    
    
    private func nextQuestion(question: Question) {
        if let index = quizSet.firstIndex(where: {$0.text == question.text}) {
            if (index < quizSet.count - 1) {
                // next quiestion
                let nextQuestion = quizSet[index + 1]
                config(question: nextQuestion)
                questionAnswers.reloadData()
            } else {
                // end the game
                performSegue(withIdentifier: "end", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AnswerViewController {
            var correctAnswer: String?
            for answer in currentAnswers {
                if (answer.corrent) {
                    correctAnswer = answer.text
                    break
                }
            }
            destination.question = currentQuestion.text
            destination.answer = correctAnswer
        }
        
        if let destination = segue.destination as? EndSceneViewController {
            destination.totalNum = quizSet.count
            destination.score = score
        }
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
