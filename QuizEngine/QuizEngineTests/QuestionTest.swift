//
//  QuestionTest.swift
//  QuizAppTests
//
//  Created by Oğuz Kaan Altun on 5.08.2023.
//

import Foundation
import XCTest
@testable import QuizApp

class QuestionTest: XCTestCase {
    
    func test_hashValue_singleAnswer_returnsTypeHash() {
        let type = "a string"

        let sut = Question.singleAnswer(type)

        XCTAssertEqual(sut.hashValue, type.hashValue)
    }

    func test_hashValue_multipleAnswer_returnsTypeHash() {
        let type = "a string"

        let sut = Question.multipleAnswer(type)

        XCTAssertEqual(sut.hashValue, type.hashValue)
    }
    
    func test_equal_isEqual() {
        XCTAssertEqual(Question.singleAnswer("a string"), Question.singleAnswer("a string"))
        XCTAssertEqual(Question.multipleAnswer("a string"), Question.multipleAnswer("a string"))
    }
    
    func test_notEqual_singleAnswerQuestions_isNotEqual() {
        XCTAssertNotEqual(Question.singleAnswer("a string"), Question.singleAnswer("another string"))
        XCTAssertNotEqual(Question.multipleAnswer("a string"), Question.multipleAnswer("another string"))
        XCTAssertNotEqual(Question.singleAnswer("a string"), Question.multipleAnswer("another string"))
        XCTAssertNotEqual(Question.singleAnswer("a string"), Question.multipleAnswer("a string"))
    }
}
