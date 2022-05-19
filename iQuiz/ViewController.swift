//
//  ViewController.swift
//  iQuiz
//
//  Created by Chuteng Li on 2022/5/10.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let fileName = "quiz"
    
    var QUIZS: [Quiz]? {
        didSet {
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var settingButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if (checkFileExist(toFileName: fileName + ".json")) {
            do {
                let json = try loadJSON(withFilename: fileName)
                if (json != nil) {
                    let jsonData = try JSONSerialization.data(withJSONObject: json!, options: .prettyPrinted)
                    QUIZS = try! JSONDecoder().decode([Quiz].self, from: jsonData)
                }
            } catch {
                alertMessage("Error happened when loading data")
            }
        } else {
            let defaultData = """
            [{"title":"Default Science!",
            "desc":"Default SCIENCE!",
            "questions":[
                {
                    "text":"Default",
                    "answer":"1",
                    "answers":[
                        "Default Answer1",
                        "Default Answer2",
                        "Default Answer3",
                        "Default Answer4"
                    ]
                }
                ]
            }]
            """
            let jsonData = defaultData.data(using: .utf8)
            print(type(of: jsonData!))
            do {
                self.QUIZS = try JSONDecoder().decode([Quiz].self, from: jsonData!)
            } catch {
                alertMessage("Error Happened when loading default data")
            }
        }
        
        table.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QUIZS?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        cell.config(title: QUIZS![indexPath.row].title!, description: QUIZS![indexPath.row].desc!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showQuiz", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? QuizVCViewController {
            destination.questions = QUIZS![(table.indexPathForSelectedRow?.row)!].questions
            // destination.category = QUIZS[(table.indexPathForSelectedRow?.row)!]["title"]
            table.deselectRow(at: table.indexPathForSelectedRow!, animated: true)
        }
    }
    
    // get URL from setting popup
    @IBAction func settingButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Setting", message: "Enter URL", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField{ textField in textField.placeholder = "Enter URL"}
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Retrieve", style: .default, handler: { action in
            guard let url = alert.textFields?.first?.text else {
                print("input proper text!")
                return
            }
            
            let request = URLRequest(url: URL(string: url)!)
            
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard self != nil else { return }
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
                else {
                    DispatchQueue.main.async {
                        self!.alertMessage("Bad Request/Bad Response/Internet Error")
                    }
                    return
                }
                
                
                if let data = data {
                    self!.QUIZS = try! JSONDecoder().decode([Quiz].self, from: data)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                        let res = try self!.saveToJson(jsonObject: json, toFileName: self!.fileName)
                        if (!res) {
                            self!.alertMessage("Error happened when saving data")
                        }
                    } catch {
                        self!.alertMessage("Error happened when saving data")
                    }
                } else {
                    DispatchQueue.main.async {
                        self!.alertMessage("Error happened when retrieving data")
                    }
                    return
                }
            }.resume()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertMessage(_ msg: String) {
        let alertController = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func saveToJson(jsonObject: Any, toFileName fileName: String) throws -> Bool {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(fileName)
            print(fileURL)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            try data.write(to: fileURL, options: [.atomicWrite])
            return true
        }
        return false
    }
    
    func loadJSON(withFilename fileName: String) throws -> Any? {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(fileName)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try Data(contentsOf: fileURL)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves])
            return jsonObject
        }
        
        return nil
    }
    
    func checkFileExist(toFileName fileName: String) -> Bool {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(fileName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    // for test use
    func deleteFile() {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            for fileURL in fileURLs where fileURL.pathExtension == "json" {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch  { print(error) }
    }
}

