//
//  ViewController.swift
//  Matching-Card
//
//  Created by 林寧 on 2023/3/17.
//

import UIKit

class ViewController: UIViewController {
    
    var game = MatchingGame()
    var flipCount: Int = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipcount)"
        }
    }
}
