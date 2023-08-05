//
//  NavigationControllerRouter.swift
//  QuizApp
//
//  Created by Oğuz Kaan Altun on 23.07.2023.
//

import UIKit
import QuizEngine

protocol ViewControllerFactory {
    func questionViewController(for question: Question<String>, answerCallback: @escaping (String) -> Void) -> UIViewController
    func resultViewController(for result: Result<Question<String>, String>) -> UIViewController
}

class NavigationControllerRouter: Router {
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func routeTo(question: Question<String>, answerCallback: @escaping (String) -> Void) {
        let viewController = factory.questionViewController(for: question, answerCallback: answerCallback)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func routeTo(result: Result<Question<String>, String>) {
        let viewController = factory.resultViewController(for: result)
        navigationController.pushViewController(viewController, animated: true)
    }
}
