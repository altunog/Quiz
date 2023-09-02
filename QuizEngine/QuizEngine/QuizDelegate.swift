//
//  QuizDelegate.swift
//  QuizEngine
//
//  Created by Oğuz Kaan Altun on 30.08.2023.
//

import Foundation

public protocol QuizDelegate {
    associatedtype Question: Hashable
    associatedtype Answer
    
    func answer(for question: Question, completion: @escaping (Answer) -> Void)
    func handle(result: Result<Question, Answer>)
}
