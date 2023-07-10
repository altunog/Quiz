//
//  Flow.swift
//  QuizEngine
//
//  Created by Oğuz Kaan Altun on 9.07.2023.
//

import Foundation

protocol Router {
    typealias AnswerCallback = (String) -> Void
    func routeTo(question: String, answerCallback: @escaping AnswerCallback)
    func routeTo(result: [String: String])
}

class Flow {
    private let router: Router
    private let questions: [String]
    private var results: [String: String] = [:]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion, answerCallback: routeNext(from: firstQuestion))
        } else {
            router.routeTo(result: self.results)
        }
    }
    
    private func routeNext(from question: String) -> Router.AnswerCallback {
        return { [weak self] answer in
            guard let self else { return }
            
            if let currentQuestionIndex = self.questions.firstIndex(of: question) {
                self.results[question] = answer
                if currentQuestionIndex + 1 < questions.count {
                    let nextQuestion = self.questions[currentQuestionIndex + 1]
                    self.router.routeTo(question: nextQuestion, answerCallback: routeNext(from: nextQuestion))
                } else {
                    self.router.routeTo(result: self.results)
                }
            }
        }
    }
}
