//
//  DeprecatedGameTest.swift
//  QuizEngineTests
//
//  Created by Oğuz Kaan Altun on 23.07.2023.
//

import Foundation
import XCTest
import QuizEngine

class QuizTest: XCTestCase {
    
    private let delegate = DelegateSpy()
    private var quiz: Quiz!
    
    override func setUp() {
        super.setUp()
        
        quiz = Quiz.start(question: ["Q1", "Q2"], delegate: delegate, correctAnswers: ["Q1": "A1", "Q2": "A2"])
    }
    
    override func tearDown() {
        super.tearDown()
        
        quiz = nil
    }
    
    func test_startQuiz_answerZeroOutOfTwoCorrectly_scoresZero() {
        delegate.answerCompletion("wrong")
        delegate.answerCompletion("wrong")
        
        XCTAssertEqual(delegate.handledResult!.score, 0)
    }
    
    func test_startQuiz_answerOneOutOfTwoCorrectly_scoresOne() {
        delegate.answerCompletion("A1")
        delegate.answerCompletion("wrong")
        
        XCTAssertEqual(delegate.handledResult!.score, 1)
    }
    
    func test_startQuiz_answerTwoOutOfTwoCorrectly_scoresTwo() {
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")
        
        XCTAssertEqual(delegate.handledResult!.score, 2)
    }
    
    
    private class DelegateSpy: QuizDelegate {
        var handledResult: Result<String, String>? = nil
        
        var answerCompletion: ((String) -> Void) = { _ in }
        
        func answer(for question: String, completion: @escaping (String) -> Void) {
            self.answerCompletion = completion
        }
        
        func handle(result: Result<String, String>) {
            handledResult = result
        }
    }
}
