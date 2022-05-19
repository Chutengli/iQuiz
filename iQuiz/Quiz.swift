//
//  Quiz.swift
//  iQuiz
//
//  Created by Chuteng Li on 2022/5/18.
//

import Foundation

struct Quiz: Decodable {
    var title: String?
    var desc: String?
    var questions: [Question]?
}
