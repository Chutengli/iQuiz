//
//  ViewController.swift
//  iQuiz
//
//  Created by Chuteng Li on 2022/5/10.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let QUIZS = [
        ["title": "Mathematics", "iconName": "math_icon", "description": "A collection of Math Quizes"],
        ["title": "Marvel Super Heroes", "iconName": "marvel_icon", "description": "A collection of Marvel Super Heroes Quizes"],
        ["title": "Science", "iconName": "science_icon", "description": "A collection of Science Quizes"]
    ]
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var settingButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        table.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QUIZS.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        
        
        cell.config(title: QUIZS[indexPath.row]["title"]!, iconName: QUIZS[indexPath.row]["iconName"]!, description: QUIZS[indexPath.row]["description"]!)
        
        print(cell.cellIcon)
        return cell
    }
    
    @IBAction func settingButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Setting", message: "Settings go here", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

