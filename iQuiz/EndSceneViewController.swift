//
//  EndSceneViewController.swift
//  iQuiz
//
//  Created by Chuteng Li on 2022/5/16.
//

import UIKit

class EndSceneViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var score: Int!
    var totalNum: Int!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scoreLabel.text = "you got \n \(score!)/\(totalNum!) questions \n correct"
        
    }
    
    
    @IBAction func backToHome(_ sender: Any) {
        performSegue(withIdentifier: "home", sender: self)
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
