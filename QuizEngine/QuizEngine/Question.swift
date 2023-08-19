//
//  Question.swift
//  QuizApp
//
//  Created by Oğuz Kaan Altun on 5.08.2023.
//

import Foundation

public enum Question<T: Hashable>: Hashable {
    case singleAnswer(T)
    case multipleAnswer(T)
}
