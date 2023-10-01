//
//  ViewControllerFactory.swift
//  QuizApp
//
//  Created by Oğuz Kaan Altun on 5.08.2023.
//

import UIKit
import QuizEngine_iOS

protocol ViewControllerFactory {
    typealias Answers = [(question: Question<String>, answer: [String])]
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController
    
    func resultViewController(for userAnswers: Answers) -> UIViewController
}
