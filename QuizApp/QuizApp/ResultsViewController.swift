//
//  ResultViewController.swift
//  QuizApp
//
//  Created by Oğuz Kaan Altun on 14.07.2023.
//

import UIKit

class ResultsViewController: UIViewController, UITableViewDataSource {
    
    private var summary = ""
    private var answers = [String]()
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    convenience init(summary: String, answers: [String]) {
        self.init()
        self.summary = summary
        self.answers = answers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = summary
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
