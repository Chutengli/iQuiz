//
//  Question.swift
//  iQuiz
//
//  Created by Chuteng Li on 2022/5/18.
//

import Foundation

struct Question: Decodable {
    var text: String?
    var answer: String?
    var answers: [String]?
}
