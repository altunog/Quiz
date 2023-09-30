//
//  NavigationControllerRouter.swift
//  QuizApp
//
//  Created by Oğuz Kaan Altun on 23.07.2023.
//

import UIKit
import QuizEngine

class NavigationControllerRouter: Router {
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func answer(for question: QuizEngine.Question<String>, completion: @escaping ([String]) -> Void) {
        switch question {
        case .singleAnswer:
            show(factory.questionViewController(for: question, answerCallback: completion))

        case .multipleAnswer:
            let button = UIBarButtonItem(title: "Submit", style: .done, target: nil, action: nil)
            let buttonController = SubmitButtonController(button: button, callback: completion)
            let controller = factory.questionViewController(for: question, answerCallback: { selection in
                buttonController.update(for: selection)
            })
            controller.navigationItem.rightBarButtonItem = button
            show(controller)

        }
    }
    
    func routeTo(question: Question<String>, answerCallback: @escaping ([String]) -> Void) {
        answer(for: question, completion: answerCallback)
    }
    
    func routeTo(result: Result<Question<String>, [String]>) {
        show(factory.resultViewController(for: result))
    }
    
    private func show(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
}

private class SubmitButtonController: NSObject {
    let button: UIBarButtonItem
    let callback: ([String]) -> Void
    private var model: [String] = []
    
    init(button: UIBarButtonItem, callback: @escaping ([String]) -> Void) {
        self.button = button
        self.callback = callback
        super.init()
        self.setup()
    }
    
    private func setup() {
        button.target = self
        button.action = #selector(fireCallback)
        updateButtonState()
    }
    
    func update(for model: [String]) {
        self.model = model
        updateButtonState()
    }
    
    private func updateButtonState() {
        button.isEnabled = model.count > 0
    }
    
    @objc private func fireCallback() {
        callback(model)
    }
}
