//
//  MatchingGame.swift
//  Matching-Card
//
//  Created by 林寧 on 2023/3/17.
//

import Foundation
import UIKit

class MatchingGame {
    var cards: Array<Card> = []
    var flipCount:Int = 0
    /*
     Initiate set Matching Game's cards
     */
    init(numberOfPairOfCards: Int) { // 需要幾“對”牌
        /* 還沒有 getUniqueIdentifier() 時，需要自己用迴圈創建新的 identifier
        for identifier in 1...numberOfPairOfCards {
            let card = Card.init(identifier: identifier)
            //cards.append(card)
            /*
            let matchingCard = card // because card is struct so pass-by-value
            cards.append(matchingCard)
            */
            //cards.append(card)
            cards += [card, card]
        }
         */
        for _ in 1...numberOfPairOfCards {
            let card = Card()
            cards += [card, card]
        }
    }
    
    func updateFlipCountLable() -> NSAttributedString{
        let flipLabelAttribute: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 20),
            .strokeColor : UIColor.brown,
            .strokeWidth : -3.0,
            .foregroundColor : UIColor.brown
        ]
        let attributeText = NSAttributedString(string: "Flips: \(flipCount)", attributes: flipLabelAttribute)
        return attributeText
    }
    
    /*
     according index to flip card
     use optional variable（initial is nil) "indexOfOneAndOnlyFaceUpCard", record one and only fliped card
     use computed property, to deal get operate and set operate
     */
    var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if !cards[index].isMatched {
                    if cards[index].isFaceUp {
                        if foundIndex == nil {
                            foundIndex = index
                        } else {
                            return nil
                        }
                    }
                }
            }
            return foundIndex
        }
        set {
            // set(newValue) -> newValue is default value (can omit)
            // set(index) -> rename newValue as index (can't omit)
            // only set metched card and oneAndOnlyFaceUp cards' isFaceUp property = true
            for flipDownIndex in cards.indices {
                if !cards[flipDownIndex].isMatched {
                    cards[flipDownIndex].isFaceUp = (flipDownIndex == newValue)
                }
            }
        }
    }
    
    /*
     estimate 1. one card face up condition 2. two card face up condition
     estimate 1. matched condition 2. not matched conditioin
     */
    func chooseCard(at index: Int) -> Card {
        if !cards[index].isMatched {
            print(cards[index])
            if let matchIndex = indexOfOneAndOnlyFaceUpCard { // second card you choosed
                print(cards[matchIndex].hashValue)
                print(cards[index].hashValue)
                if matchIndex != index {
                    /* match two cards */
                    if cards[matchIndex] == cards[index] {
                        cards[matchIndex].isMatched = true
                        cards[index].isMatched = true
                    }
                    cards[index].isFaceUp = true
                    // because it's already deal in th computed property so we don't need to set it = nil
                    // after matched, turn indexOfOneAndOnlyFaceUpCard to nil
                    // indexOfOneAndOnlyFaceUpCard = nil
                } else {
                    cards[index].isFaceUp = false
                    // after matched, turn
                    indexOfOneAndOnlyFaceUpCard = nil
                }
                
            } else { /* first card you choosed */
                /*
                // because it's already deal in th computed property so we don't need to set isFaceUp = false or true
                 
                // flip card that haven't matched down
                for flipDownIndex in cards.indices {
                    if !cards[flipDownIndex].isMatched {
                        cards[flipDownIndex].isFaceUp = false
                    }
                }
                cards[index].isFaceUp = true
                 */
                
                /* record first choosed card's index */
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        return cards[index]
    }
}
