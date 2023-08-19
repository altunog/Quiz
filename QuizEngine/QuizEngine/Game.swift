//
//  Game.swift
//  QuizEngine
//
//  Created by Oğuz Kaan Altun on 23.07.2023.
//

import Foundation

public class Game<Question, Answer, R: Router> where R.Question == Question, R.Answer == Answer {
    let flow: Flow<Question, Answer, R>
    
    init(flow: Flow<Question, Answer, R>) {
        self.flow = flow
    }
}

public func startGame<Question, Answer: Equatable, R: Router>(question: [Question], router: R, correctAnswers: [Question: Answer]) -> Game<Question, Answer, R>{
    let flow = Flow(questions: question, router: router, scoring: { answers in
        return scoring(answers, correctAnswers: correctAnswers)
    })
    flow.start()
    return Game(flow: flow)
}

private func scoring<Question, Answer: Equatable> (_ answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int {
    return answers.reduce(0) { score, tuple in
        return score + (correctAnswers[tuple.key] == tuple.value ? 1 : 0)
    }
}
