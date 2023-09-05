//
//  ScoreTest.swift
//  QuizEngine
//
//  Created by Oğuz Kaan Altun on 5.09.2023.
//

import Foundation
import XCTest

class ScoreTest: XCTestCase {
    
    func test_noAnswers_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: [], comparingTo: []), 0)
    }
    
    func test_oneWrongAnswer_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: ["wrong"], comparingTo: ["correct"]), 0)
    }
    
    private class BasicScore {
        static func score(for: [Any], comparingTo: [Any]) -> Int {
            return 0
        }
    }
}
