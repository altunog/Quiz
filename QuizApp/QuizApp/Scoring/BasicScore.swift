//
//  BasicScore.swift
//  QuizApp
//
//  Created by Oğuz Kaan Altun on 24.09.2023.
//

import Foundation

final class BasicScore {
    static func score(for answers: [String], comparingTo correctAnswers: [String]) -> Int {
        return zip(answers, correctAnswers).reduce(0) { score, tuple in
            score + (tuple.0 == tuple.1 ? 1 : 0)
        }
    }
}
