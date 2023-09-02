//
//  Game.swift
//  QuizEngine
//
//  Created by Oğuz Kaan Altun on 23.07.2023.
//

import Foundation

@available(*, deprecated)
public protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer
    
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<Question, Answer>)
}

@available(*, deprecated)
public class Game<Question, Answer, R: Router> {
    let flow: Any
    
    init(flow: Any) {
        self.flow = flow
    }
}

@available(*, deprecated)
public func startGame<Question, Answer: Equatable, R: Router>(question: [Question], router: R, correctAnswers: [Question: Answer]) -> Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer {
    let flow = Flow(questions: question, delegate: QuizDelegateToRouterAdapter(router, correctAnswers), scoring: { scoring($0, correctAnswers: correctAnswers) })
    flow.start()
    return Game(flow: flow)
}

@available(*, deprecated)
private class QuizDelegateToRouterAdapter<R: Router>: QuizDelegate where R.Answer: Equatable {
    private let router: R
    private let correctAnswers: [R.Question: R.Answer]
    
    init(_ router: R, _ correctAnswers: [R.Question: R.Answer]) {
        self.router = router
        self.correctAnswers = correctAnswers
    }
    
    func answer(for question: R.Question, completion: @escaping (R.Answer) -> Void) {
        router.routeTo(question: question, answerCallback: completion)
    }
    
    func didCompleteQuiz(withAnswers answers: [(question: R.Question, answer: R.Answer)]) {
        let answersDictionary = answers.reduce([R.Question: R.Answer](), { acc, tuple in
            var acc = acc
            acc[tuple.question] = tuple.answer
            return acc
        })
        
        let score = scoring(answersDictionary, correctAnswers: correctAnswers)
        let result = Result(answers: answersDictionary, score: score)
        router.routeTo(result: result)
    }
    
    func handle(result: Result<R.Question, R.Answer>) {}
}
