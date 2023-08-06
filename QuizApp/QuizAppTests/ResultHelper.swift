//
//  ResultHelper.swift
//  QuizAppTests
//
//  Created by Oğuz Kaan Altun on 6.08.2023.
//

import Foundation
import QuizEngine

extension Result: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(1)
    }
    
    public static func == (lhs: QuizEngine.Result<Question, Answer>, rhs: QuizEngine.Result<Question, Answer>) -> Bool {
        return lhs.score == rhs.score
    }
}
