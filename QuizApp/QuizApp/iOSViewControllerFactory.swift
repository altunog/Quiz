//
//  iOSViewControllerFactory.swift
//  QuizApp
//
//  Created by Oğuz Kaan Altun on 5.08.2023.
//

import UIKit
import QuizEngine

class iOSViewControllerFactory: ViewControllerFactory {
    
    private let options: [Question<String> : [String]]
    
    init(options: [Question<String> : [String]]) {
        self.options = options
    }
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        guard let options = options[question] else {
            fatalError("Couldn't find options for question \(question)")
        }
       
        return questionViewController(for: question, options: options, answerCallback: answerCallback)
    }
    
    private func questionViewController(for question: Question<String>, options: [String], answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        switch question {
        case .singleAnswer(let value):
            return QuestionViewController(question: value, options: options, selection: answerCallback)
        case .multipleAnswer(let value):
            let controller = QuestionViewController(question: value, options: options, selection: answerCallback)
            _ = controller.view
            controller.tableView.allowsMultipleSelection = true
            return controller
        }
    }
    
    func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
        return UIViewController()
    }
    
    
}
