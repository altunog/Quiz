//
//  Flow.swift
//  QuizEngine
//
//  Created by Oğuz Kaan Altun on 9.07.2023.
//

import Foundation

protocol Router {
    func routeTo(question: String, answerCallback: @escaping (String) -> Void)
}

class Flow {
    let router: Router
    let questions: [String]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion) { [weak self] answer in
                guard let self else { return }
                let firstQuestionIndex = questions.firstIndex(of: firstQuestion)!
                let nextQuestion = self.questions[firstQuestionIndex + 1]
                self.router.routeTo(question: nextQuestion) { _ in }
            }
        }
    }
}
