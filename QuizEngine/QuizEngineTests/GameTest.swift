//
//  GameTest.swift
//  QuizEngineTests
//
//  Created by Oğuz Kaan Altun on 23.07.2023.
//

import Foundation
import XCTest
import QuizEngine

class GameTest: XCTestCase {
    
    let router = RouterSpy()
    var game: Game<String, String, RouterSpy>!
    
    override func setUp() {
        super.setUp()
        
        game = startGame(question: ["Q1", "Q2"], router: router, correctAnswers: ["Q1": "A1", "Q2": "A2"])
    }
    
    override func tearDown() {
        super.tearDown()
        
        game = nil
    }
    
    func test_startGame_answerZeroOutOfTwoCorrectly_scoresZero() {
        router.answerCallback("wrong")
        router.answerCallback("wrong")
        
        XCTAssertEqual(router.routedResult!.score, 0)
    }
    
    func test_startGame_answerOneOutOfTwoCorrectly_scoresOne() {
        router.answerCallback("A1")
        router.answerCallback("wrong")
        
        XCTAssertEqual(router.routedResult!.score, 1)
    }
    
    func test_startGame_answerTwoOutOfTwoCorrectly_scoresTwo() {
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedResult!.score, 2)
    }
}