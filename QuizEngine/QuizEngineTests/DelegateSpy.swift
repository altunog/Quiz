//
//  DelegateSpy.swift
//  QuizEngine
//
//  Created by Oğuz Kaan Altun on 24.09.2023.
//

import Foundation
import QuizEngine

class DelegateSpy: QuizDelegate {
    var questionsAsked: [String] = []
    var answerCompletions: [(String) -> Void] = []

    var completedQuizzes: [[(String, String)]] = []
    
    func answer(for question: String, completion: @escaping (String) -> Void) {
        questionsAsked.append(question)
        answerCompletions.append(completion)
    }
    
    func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
        completedQuizzes.append(answers)
    }
}
