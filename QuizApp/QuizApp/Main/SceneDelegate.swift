//
//  SceneDelegate.swift
//  QuizApp
//
//  Created by Oğuz Kaan Altun on 10.07.2023.
//

import UIKit
import QuizEngine_iOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var game: Quiz?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let question1 = Question.singleAnswer("What's Mike's nationality?")
        let question2 = Question.multipleAnswer("What's Caio's nationality?")
        let questions = [question1, question2]
        
        let option1 = "Canadian"
        let option2 = "American"
        let option3 = "Greek"
        let options1 = [option1, option2, option3]
        
        let option4 = "Portuguese"
        let option5 = "American"
        let option6 = "Brazillian"
        let options2 = [option4, option5, option6]
        
        let options = [question1: options1, question2: options2]
        let correctAnswers = [(question1, [option3]), (question2, [option4, option6])]
        let factory = iOSViewControllerFactory(options: options, correctAnswers: correctAnswers)
        
        let navigationController = UINavigationController()
        let router = NavigationControllerRouter(navigationController, factory: factory)
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        game = Quiz.start(question: questions, delegate: router)
    }
}

