//
//  Result.swift
//  QuizEngine
//
//  Created by Oğuz Kaan Altun on 23.07.2023.
//

import Foundation

public struct Result<Question: Hashable, Answer> {
    public let answers: [Question: Answer]
    public let score: Int
}
