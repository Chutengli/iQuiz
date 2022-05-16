//
//  QuizVCViewController.swift
//  iQuiz
//
//  Created by Chuteng Li on 2022/5/15.
//

import UIKit

struct QuizQuestions {
    let text: String
    var answers: [Answer]
}

struct Answer {
    let text: String
    let corrent: Bool
}

class QuizVCViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var questionAnswers: UITableView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var category: String!
    var currentQuestion: QuizQuestions!
    var quizSet: [QuizQuestions]!
    var score = 0
    var showedAnswer: Bool!
    var selectedIndex: Int!
    
    let mathQuestions = [
        QuizQuestions(text: "1 + 1 = ?", answers: [
            Answer(text: "2", corrent: true),
            Answer(text: "1", corrent: false),
            Answer(text: "3", corrent: false),
            Answer(text: "4", corrent: false),
        ]),
        QuizQuestions(text: "1 + 2 = ?", answers: [
            Answer(text: "2", corrent: false),
            Answer(text: "1", corrent: false),
            Answer(text: "3", corrent: true),
            Answer(text: "4", corrent: false),
        ]),
        QuizQuestions(text: "2 + 2 = ?", answers: [
            Answer(text: "2", corrent: false),
            Answer(text: "1", corrent: false),
            Answer(text: "3", corrent: false),
            Answer(text: "4", corrent: true),
        ]),
        QuizQuestions(text: "3 + 3 = ?", answers: [
            Answer(text: "6", corrent: true),
            Answer(text: "1", corrent: false),
            Answer(text: "3", corrent: false),
            Answer(text: "4", corrent: false),
        ]),
    ]
    
    let marvelQuestions = [
        QuizQuestions(text: "Tony Stark?", answers: [
            Answer(text: "Iron Man", corrent: true),
            Answer(text: "American Captain", corrent: false),
            Answer(text: "Hulk", corrent: false),
            Answer(text: "Spider Man", corrent: false),
        ]),
        QuizQuestions(text: "Not Marvel Hero?", answers: [
            Answer(text: "Iron Man", corrent: false),
            Answer(text: "Amcerican Captain", corrent: false),
            Answer(text: "Bat Man", corrent: true),
            Answer(text: "Spider Man", corrent: false),
        ])
    ]
    
    let scienceQuestions = [
        QuizQuestions(text: "Water?", answers: [
            Answer(text: "H2O", corrent: true),
            Answer(text: "SO2", corrent: false),
            Answer(text: "Fu", corrent: false),
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionAnswers.delegate = self
        questionAnswers.dataSource = self
        
        setupQuestion()
    }
    
    private func setupQuestion() {
        let question: QuizQuestions?
        switch category {
        case "Mathematics":
            quizSet = mathQuestions
            question = mathQuestions.first
        case "Marvel Super Heroes":
            quizSet = marvelQuestions
            question = marvelQuestions.first
        default:
            quizSet = scienceQuestions
            question = scienceQuestions.first
        }
        config(question: question!)
    }
    
    private func config(question: QuizQuestions) {
        questionLabel.text = question.text
        currentQuestion = question
    }
    
    // Table view functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestion?.answers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quizCell", for: indexPath)
        cell.textLabel?.text = currentQuestion?.answers[indexPath.row].text
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
            let answer = question.answers[selectedIndex]
            
            if (answer.corrent) {
                score += 1
            }
        }
                
        //show answer page
        performSegue(withIdentifier: "showAnswer", sender: self)
        nextQuestion(question: question)
        // check Answer
    }
    
    
    private func nextQuestion(question: QuizQuestions) {
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
            var correct: String?
            for answer in currentQuestion.answers {
                if (answer.corrent) {
                    correct = answer.text
                    break
                }
            }
            destination.question = currentQuestion.text
            destination.answer = correct
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
