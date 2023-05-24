//
//  Card.swift
//  Matching-Card
//
//  Created by 林寧 on 2023/3/17.
//

import Foundation

struct Card : Hashable {
    
    // hash value
    var hashValue: Int {
        // card's id
        return identifier
    }
    // compare two card
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier()->Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
