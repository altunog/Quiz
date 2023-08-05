//
//  NavigationControllerRouter.swift
//  QuizAppTests
//
//  Created by Oğuz Kaan Altun on 23.07.2023.
//

import UIKit
import XCTest
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
    
    func test_routeToQuestion_showsQuestionControllerWithRightCallback() {
        var callbackWasFired = false
        
        sut.routeTo(question: Question.singleAnswer("Q1"), answerCallback: { _ in  callbackWasFired = true })
        factory.answerCallbacks[Question.singleAnswer("Q1")]!("an answer")
        
        XCTAssertTrue(callbackWasFired)
    }
    
    
    class NonAnimatedNavigationController: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }
    
    class ViewControllerFactoryStub: ViewControllerFactory {
        
        var stubbedQuestions = [Question<String>: UIViewController]()
        var answerCallbacks = [Question<String>: (String) -> Void]()
        
        func stub(question: Question<String>, with viewController: UIViewController) {
            stubbedQuestions[question] = viewController
        }
        
        func questionViewController(for question: Question<String>, answerCallback: @escaping (String) -> Void) -> UIViewController {
            answerCallbacks[question] = answerCallback
            return stubbedQuestions[question] ?? UIViewController()
        }
    }
}
