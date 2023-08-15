//
//  ResultHelper.swift
//  QuizAppTests
//
//  Created by Oğuz Kaan Altun on 6.08.2023.
//

@testable import QuizEngine

extension Result: Hashable {

    static func make(answers: [Question: Answer] = [:], score: Int = 0) -> Result<Question, Answer> {
        return Result(answers: answers, score: score)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(1)
    }
    
    public static func == (lhs: QuizEngine.Result<Question, Answer>, rhs: QuizEngine.Result<Question, Answer>) -> Bool {
        return lhs.score == rhs.score
    }
}
