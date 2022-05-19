//
//  TableViewCell.swift
//  iQuiz
//
//  Created by Chuteng Li on 2022/5/11.
//

import UIKit

class TableViewCell: UITableViewCell {
    static let identifier = "TableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "TableViewCell", bundle: nil)
    }
    
    public func config(title: String, description: String) {
        cellTitle.text = title
        cellDescription.text = description
    }

    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDescription: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellDescription.isEditable = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
