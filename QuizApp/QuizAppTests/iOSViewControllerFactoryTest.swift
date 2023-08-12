//
//  iOSViewControllerFactoryTest.swift
//  QuizAppTests
//
//  Created by Oğuz Kaan Altun on 5.08.2023.
//

import Foundation
import XCTest
import QuizEngine
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
        XCTAssertFalse(makeQuestionController().allowsMultipleSelection)
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
        XCTAssertTrue(makeQuestionController(question: multipleAnswerQuestion).allowsMultipleSelection)
    }
    
    func test_resultsViewController_createsControllerWithSummary() {
        let questions = [singleAnswerQuestion, multipleAnswerQuestion]
        let userAnswers = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A1", "A2"]]
        let correctAnswers = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A1", "A2"]]
        
        let result = Result(answers: userAnswers, score: 2)
        let presenter = ResultsPresenter(result: result, questions: questions, correctAnswers: correctAnswers)
        let sut = makeSUT(correctAnswers: correctAnswers)
        
        let controller = sut.resultViewController(for: result) as? ResultsViewController
        
        XCTAssertEqual(controller?.summary, presenter.summary)
    }
    
    func test_resultsViewController_createsControllerWithPresentableAnswers() {
        let questions = [singleAnswerQuestion, multipleAnswerQuestion]
        let userAnswers = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A1", "A2"]]
        let correctAnswers = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A1", "A2"]]
        
        let result = Result(answers: userAnswers, score: 2)
        let presenter = ResultsPresenter(result: result, questions: questions, correctAnswers: correctAnswers)
        let sut = makeSUT(correctAnswers: correctAnswers)
        
        let controller = sut.resultViewController(for: result) as? ResultsViewController
        
        XCTAssertEqual(controller?.answers.count, presenter.presentableAnswers.count)
    }
    
    // MARK: Helpers
    
    func makeSUT(options: [Question<String> : [String]] = [:], correctAnswers: [Question<String> : [String]] = [:]) -> iOSViewControllerFactory {
        let sut = iOSViewControllerFactory(questions: [singleAnswerQuestion, multipleAnswerQuestion], options: options, correctAnswers: correctAnswers)
        return sut
    }
    
    func makeQuestionController(question: Question<String> = Question.singleAnswer("")) -> QuestionViewController {
        return makeSUT(options: [question: options]).questionViewController(for: question, answerCallback: {_ in} ) as! QuestionViewController
    }
}
