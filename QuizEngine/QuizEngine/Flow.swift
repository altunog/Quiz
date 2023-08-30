//
//  Flow.swift
//  QuizEngine
//
//  Created by Oğuz Kaan Altun on 9.07.2023.
//

import Foundation

class Flow<R: Router> {
    typealias Question = R.Question
    typealias Answer = R.Answer
    
    private let router: R
    private let questions: [Question]
    private var answers: [Question: Answer] = [:]
    private var scoring: ([Question: Answer]) -> Int
    
    init(questions: [Question], router: R, scoring: @escaping ([Question: Answer]) -> Int) {
        self.questions = questions
        self.router = router
        self.scoring = scoring
    }
    
    func start() {
        routeToQuestion(at: questions.startIndex)
    }
    
    private func routeToQuestion(at index: Int) {
        if index < questions.endIndex {
            let question = questions[index]
            router.routeTo(question: question, answerCallback: callback(for: question, at: index))
        } else {
            router.routeTo(result: result())
        }
    }
    
    private func callback(for question: Question, at index: Int) -> (Answer) -> Void {
        return { [weak self] answer in
            self?.answers[question] = answer
            self?.routeToQuestion(after: index)
        }
    }
    
    private func routeToQuestion(after index: Int) {
        routeToQuestion(at: questions.index(after: index))
    }
    
    private func result() -> Result<Question, Answer> {
        return Result(answers: answers, score: scoring(answers))
    }
}
