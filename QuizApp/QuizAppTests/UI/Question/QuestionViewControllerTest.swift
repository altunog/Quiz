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
    
    func test_viewDidLoad_withSingleSelection_configuresTableView() {
        XCTAssertFalse(makeSUT(options: ["A1", "A2"], allowsMultipleSelection: false).allowsMultipleSelection)
    }
    
    func test_viewDidLoad_withMultipleSelection_configuresTableView() {
        XCTAssertTrue(makeSUT(options: ["A1", "A2"], allowsMultipleSelection: true).allowsMultipleSelection)
    }
    
    
    func test_viewDidLoad_rendersOptionTexts() {
        let sut = makeSUT(options: ["A1", "A2"])
        
        XCTAssertEqual(sut.tableView.title(at: 0), "A1")
        XCTAssertEqual(sut.tableView.title(at: 1), "A2")
    }
    
    func test_optionSelected_notifiesDelegate() {
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1"]) { receivedAnswer = $0 }
        
        sut.tableView.select(at: 0)
        
        XCTAssertEqual(receivedAnswer, ["A1"])
    }
    
    func test_optionSelected_withSingleSelection_notifiesDelegateWithLastSelection() {
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: false) { receivedAnswer = $0 }
        
        sut.tableView.select(at: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        sut.tableView.select(at: 1)
        XCTAssertEqual(receivedAnswer, ["A2"])
    }
    
    func test_optionSelected_withSingleSelection_doesNotNotifiesDelegateWithEmptySelection() {
        var callbackCount = 0
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: false) { _ in callbackCount += 1 }
        
        sut.tableView.select(at: 0)
        XCTAssertEqual(callbackCount, 1)
        
        sut.tableView.deselect(at: 0)
        XCTAssertEqual(callbackCount, 1)
    }
    
    func test_optionSelected_withMultipleSelectionEnabled_notifiesDelegate() {
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: true) { receivedAnswer = $0 }
        
        sut.tableView.select(at: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])

        sut.tableView.select(at: 1)
        XCTAssertEqual(receivedAnswer, ["A1", "A2"])
    }
    
    func test_optionDeselected_withMultipleSelectionEnabled_notifiesDelegate() {
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: true) { receivedAnswer = $0 }

        sut.tableView.select(at: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])

        sut.tableView.deselect(at: 0)
        XCTAssertEqual(receivedAnswer, [])
    }
    
    // MARK: Helpers
    
    func makeSUT(question: String = "",
                 options: [String] = [],
                 allowsMultipleSelection: Bool = false,
                 selection: @escaping ([String]) -> Void = { _ in }) -> QuestionViewController {
        let sut = QuestionViewController(question: question, options: options, allowsMultipleSelection: allowsMultipleSelection, selection: selection)
        sut.loadViewIfNeeded()
        return sut
    }
}
