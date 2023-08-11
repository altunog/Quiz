//
//  iOSViewControllerFactoryTest.swift
//  QuizAppTests
//
//  Created by Oğuz Kaan Altun on 5.08.2023.
//

import Foundation
import XCTest
@testable import QuizApp

class iOSViewControllerFactoryTest: XCTestCase {
    
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q2")
    let options = ["A1", "A2"]
    
    func test_questionViewController_singleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: singleAnswerQuestion)
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).title, presenter.title)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController().options, options)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithSingleSelection() {
        let controller = makeQuestionController()
        _ = controller.view
        XCTAssertFalse(controller.tableView.allowsMultipleSelection)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: multipleAnswerQuestion)
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion ).title, presenter.title)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).question, "Q2")
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController().options, options)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithMultipleSelection() {
        let controller = makeQuestionController(question: multipleAnswerQuestion)

        XCTAssertTrue(controller.tableView.allowsMultipleSelection)
    }
    
    // MARK: Helpers
    
    func makeSUT(options: [Question<String> : [String]]) -> iOSViewControllerFactory {
        let sut = iOSViewControllerFactory(questions: [singleAnswerQuestion, multipleAnswerQuestion ], options: options)
        return sut
    }
    
    func makeQuestionController(question: Question<String> = Question.singleAnswer("")) -> QuestionViewController {
        return makeSUT(options: [question: options]).questionViewController(for: question, answerCallback: {_ in} ) as! QuestionViewController
    }
}
