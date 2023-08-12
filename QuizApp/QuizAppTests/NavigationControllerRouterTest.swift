//
//  NavigationControllerRouter.swift
//  QuizAppTests
//
//  Created by Oğuz Kaan Altun on 23.07.2023.
//

import UIKit
import XCTest
import QuizEngine
@testable import QuizApp

class NavigationControllerRouterTest: XCTestCase {
    
    let navigationController = NonAnimatedNavigationController()
    let factory = ViewControllerFactoryStub()
    
    lazy var sut: NavigationControllerRouter = {
        NavigationControllerRouter(navigationController, factory: factory)
    }()
    
    func test_routeToSecondQuestion_showsQuestionControllers() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        factory.stub(question: Question.singleAnswer("Q1"), with: viewController)
        factory.stub(question: Question.singleAnswer("Q2"), with: secondViewController)
        
        sut.routeTo(question: Question.singleAnswer("Q1"), answerCallback: { _ in })
        sut.routeTo(question: Question.singleAnswer("Q2"), answerCallback: { _ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuestion_singleAnswer_answerCallback_progressesToNextQuestion() {
        var callbackWasFired = false
        
        sut.routeTo(question: Question.singleAnswer("Q1"), answerCallback: { _ in  callbackWasFired = true })
        factory.answerCallbacks[Question.singleAnswer("Q1")]!(["A1"])
        
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_routeToQuestion_multipleAnswer_answerCallback_doesNotProgressesToNextQuestion() {
        var callbackWasFired = false
        
        sut.routeTo(question: Question.multipleAnswer("Q1"), answerCallback: { _ in  callbackWasFired = true })
        factory.answerCallbacks[Question.multipleAnswer("Q1")]!(["A1"])
        
        XCTAssertFalse(callbackWasFired)
    }
    
    func test_routeToQuestion_multipleAnswer_configuresViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: Question.multipleAnswer("Q1"), with: viewController)
        
        sut.routeTo(question: Question.multipleAnswer("Q1"), answerCallback: { _ in })
        
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    
    func test_routeToQuestion_multipleAnswerSubmitButton_isDisabledWhenZeroAnswersSelected() {
        let viewController = UIViewController()
        factory.stub(question: Question.multipleAnswer("Q1"), with: viewController)
        
        sut.routeTo(question: Question.multipleAnswer("Q1"), answerCallback: { _ in })
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallbacks[Question.multipleAnswer("Q1")]!(["A1"])
        XCTAssertTrue(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        
        factory.answerCallbacks[Question.multipleAnswer("Q1")]!([])
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func test_routeToQuestion_multipleAnswerSubmitButton_ProgressToNextQuestion() {
        let viewController = UIViewController()
        factory.stub(question: Question.multipleAnswer("Q1"), with: viewController)
        
        var callbackWasFired = false
        sut.routeTo(question: Question.multipleAnswer("Q1"), answerCallback: { _ in  callbackWasFired = true })
        
        factory.answerCallbacks[Question.multipleAnswer("Q1")]!(["A1"])
        let button = viewController.navigationItem.rightBarButtonItem!
        button.target!.perform(button.action!, on: .main, with: nil, waitUntilDone: true)
        
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_routeToResult_showsResultViewController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        let result = Result(answers: [Question.singleAnswer("Q1"): ["A1"]], score: 10)
        let secondResult = Result(answers: [Question.singleAnswer("Q2"): ["A2"]], score: 20)
        
        factory.stub(result: result, with: viewController)
        factory.stub(result: secondResult, with: secondViewController)
        
        sut.routeTo(result: result)
        sut.routeTo(result: secondResult)
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    
    // MARK: Helpers
    
    class NonAnimatedNavigationController: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }
    
    class ViewControllerFactoryStub: ViewControllerFactory {
        
        var stubbedQuestions = [Question<String>: UIViewController]()
        var stubbedResults = [Result<Question<String>, [String]>: UIViewController]()
        var answerCallbacks = [Question<String>: ([String]) -> Void]()
        
        func stub(question: Question<String>, with viewController: UIViewController) {
            stubbedQuestions[question] = viewController
        }
        
        func stub(result: Result<Question<String>, [String]>, with viewController: UIViewController) {
            stubbedResults[result] = viewController
        }
        
        func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
            answerCallbacks[question] = answerCallback
            return stubbedQuestions[question] ?? UIViewController()
        }
        
        func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
            return stubbedResults[result] ?? UIViewController()
        }
    }
}
