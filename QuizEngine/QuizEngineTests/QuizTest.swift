//
//  DeprecatedGameTest.swift
//  QuizEngineTests
//
//  Created by Oğuz Kaan Altun on 23.07.2023.
//

import Foundation
import XCTest
@testable import QuizEngine

final class Quiz {
    let flow: Any
    
    init(flow: Any) {
        self.flow = flow
    }
    
    static func start<Question, Answer: Equatable, Delegate: QuizDelegate>(question: [Question], delegate: Delegate, correctAnswers: [Question: Answer]) -> Quiz where Delegate.Question == Question, Delegate.Answer == Answer {
        let flow = Flow(questions: question, delegate: delegate, scoring: { answers in
            return scoring(answers, correctAnswers: correctAnswers)
        })
        flow.start()
        return Quiz(flow: flow)
    }
}

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
        delegate.answerCallback("wrong")
        delegate.answerCallback("wrong")
        
        XCTAssertEqual(delegate.handledResult!.score, 0)
    }
    
    func test_startQuiz_answerOneOutOfTwoCorrectly_scoresOne() {
        delegate.answerCallback("A1")
        delegate.answerCallback("wrong")
        
        XCTAssertEqual(delegate.handledResult!.score, 1)
    }
    
    func test_startQuiz_answerTwoOutOfTwoCorrectly_scoresTwo() {
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.handledResult!.score, 2)
    }
    
    
    private class DelegateSpy: Router, QuizDelegate {
        var handledResult: Result<String, String>? = nil
        
        var answerCallback: ((String) -> Void) = { _ in }
        
        func handle(question: String, answerCallback: @escaping (String) -> Void) {
            self.answerCallback = answerCallback
        }
        
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            handle(question: question, answerCallback: answerCallback)
        }
        
        func handle(result: Result<String, String>) {
            handledResult = result
        }
        
        func routeTo(result: Result<String, String>) {
            handle(result: result)
        }
    }
}
