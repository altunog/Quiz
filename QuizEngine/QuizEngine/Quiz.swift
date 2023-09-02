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
    
    public static func start<Delegate: QuizDelegate>(
        question: [Delegate.Question],
        delegate: Delegate
    ) -> Quiz where Delegate.Answer: Equatable {
        let flow = Flow(
            questions: question,
            delegate: delegate
        )
        flow.start()
        return Quiz(flow: flow)
    }
}

func scoring<Question, Answer: Equatable> (_ answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int {
    return answers.reduce(0) { score, tuple in
        return score + (correctAnswers[tuple.key] == tuple.value ? 1 : 0)
    }
}
