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
    let flow = Flow(questions: question, delegate: QuizDelegateToRouterAdapter(router), scoring: { answers in
        return scoring(answers, correctAnswers: correctAnswers)
    })
    flow.start()
    return Game(flow: flow)
}

@available(*, deprecated)
private class QuizDelegateToRouterAdapter<R: Router>: QuizDelegate {
    private let router: R
    
    init(_ router: R) {
        self.router = router
    }
    
    func handle(question: R.Question, answerCallback: @escaping (R.Answer) -> Void) {
        router.routeTo(question: question, answerCallback: answerCallback)
    }
    
    func handle(result: Result<R.Question, R.Answer>) {
        router.routeTo(result: result)
    }
}

func scoring<Question, Answer: Equatable> (_ answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int {
    return answers.reduce(0) { score, tuple in
        return score + (correctAnswers[tuple.key] == tuple.value ? 1 : 0)
    }
}
