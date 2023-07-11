//
//  QuestionViewController.swift
//  QuizAppTests
//
//  Created by Oğuz Kaan Altun on 10.07.2023.
//

import Foundation
import XCTest
@testable import QuizApp

class QuestionViewControllerTest: XCTestCase {
    
    func test_viewDidLoad_rendersQuestionHeaderText() {
        XCTAssertEqual(makeSUT(question: "Q1").headerLabel.text, "Q1")
    }
    
    func test_viewDidLoad_rendersOptions() {
        XCTAssertEqual(makeSUT(options: []).tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(options: ["A1"]).tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(makeSUT(options: ["A1", "A2"]).tableView.numberOfRows(inSection: 0), 2)
    }
    
    func test_viewDidLoad_rendersOptionTexts() {
        let sut = makeSUT(options: ["A1", "A2"])
        
        XCTAssertEqual(sut.tableView.title(at: 0), "A1")
        XCTAssertEqual(sut.tableView.title(at: 1), "A2")
    }
    
    func test_optionSelected_notifiesDelegate() {
        var receivedAnswer = ""
        let sut = makeSUT(options: ["A1"]) {
            receivedAnswer = $0
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        sut.tableView.delegate?.tableView?(sut.tableView, didSelectRowAt: indexPath)
        XCTAssertEqual(receivedAnswer, "A1")
    }
    
    // MARK: Helpers
    
    func makeSUT(question: String = "",
                 options: [String] = [],
                 selection: @escaping (String) -> Void = { _ in }) -> QuestionViewController {
        let sut = QuestionViewController(question: question, options: options, selection: selection)
        _ = sut.view
        return sut
    }
}

fileprivate extension UITableView {
    
    func cell(at row: Int) -> UITableViewCell? {
        dataSource?.tableView(self, cellForRowAt: IndexPath(row: row, section: 0))
    }
    
    func title(at row: Int) -> String? {
        cell(at: row)?.textLabel?.text
    }
}
