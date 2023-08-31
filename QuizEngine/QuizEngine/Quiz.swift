//
//  Quiz.swift
//  QuizEngine
//
//  Created by Oğuz Kaan Altun on 31.08.2023.
//

import Foundation

public final class Quiz {
    let flow: Any
    
    init(flow: Any) {
        self.flow = flow
    }
    
    public static func start<Question, Answer: Equatable, Delegate: QuizDelegate>(question: [Question], delegate: Delegate, correctAnswers: [Question: Answer]) -> Quiz where Delegate.Question == Question, Delegate.Answer == Answer {
        let flow = Flow(questions: question, delegate: delegate, scoring: { answers in
            return scoring(answers, correctAnswers: correctAnswers)
        })
        flow.start()
        return Quiz(flow: flow)
    }
}
