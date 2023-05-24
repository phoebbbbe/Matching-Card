//
//  ViewController.swift
//  Matching-Card
//
//  Created by 林寧 on 2023/3/10.
//

import UIKit

class ViewController: UIViewController {
    var isFlipAll = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         初始：更新翻牌數、牌設定是反面
         */
        isFlipAll = false
        flipCountLabel.attributedText = game.updateFlipCountLable()
        let font = UIFont.systemFont(ofSize: 35)
        let attribute = [NSAttributedString.Key.font : font]
        for i in 0...15 {
            if cardsButton[i].currentAttributedTitle == nil {
                let message = NSAttributedString(string: "?", attributes: attribute)
                cardsButton[i].setAttributedTitle(message, for: UIControl.State.normal)
                cardsButton[i].backgroundColor = #colorLiteral(red: 0.2830694318, green: 0.4954899549, blue: 0.6407209039, alpha: 1)
            }
        }
        /* 打亂 cardsButton 的順序*/
        cardsButton.shuffle()
    }
    
    /*
     Design an NSAttributedString 設計 Flips 的字體，使其維持
     */
    /*
    private func updateFlipCountLable() {
        let flipLabelAttribute: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 20),
            .strokeColor : UIColor.brown,
            .strokeWidth : -3.0,
            .foregroundColor : UIColor.brown
        ]
        let attributeText = NSAttributedString(string: "Flips: \(flipCount)", attributes: flipLabelAttribute)
        flipCountLabel.attributedText = attributeText
    }
     */
    
    /* lazy
     可以等元件都set好之後MatchingGame才會開始作用，所以不用立刻初始化
     但是就不能使用didSet
    */
    lazy var game = MatchingGame(numberOfPairOfCards: numberOfPairsCard)
    var numberOfPairsCard: Int {
        return cardsButton.count/2
    }
    
    var emojiChoices = ["😀","🥰","🥳","🤪","🥹","🤢","😎","🤩"]
    var emoji = Dictionary<Card, String>()
    
    func getEmoji(at card: Card) -> String {
        /*
        if index < emojiChoices.count{
            return emojiChoices[index]
        } else {
            return "?"
        }
         */
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomIndex = emojiChoices.count.arc4random // Unsigned Integer
            emoji[card] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card] ?? "?"
    }
    
    @IBOutlet var cardsButton: [UIButton]!
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBAction func touchCard(_ sender: UIButton) {
        //第三種寫法 : 透過 game.chooseCard
        if let cardIndex = cardsButton.firstIndex(of: sender) {
            let choosedCard = game.chooseCard(at: cardIndex)
            updateViewFromModel()
        }
        /* 第一種寫法 : 使用 sender.currentTitle
         emoji 的大小在 touchCard
         後會變小，無法維持設定的 size 為 35
        ===================================
         var title = ""
         // 確保 titleLable 不會是 nil，用 title 取出
         if let tit = sender.titleLabel!.text {
             title = tit
         }
         
        if sender.currentTitle == nil {
            sender.setTitle(title, for: UIControl.State.normal)
        }
        
        if sender.currentTitle == title {
            sender.setTitle("", for: UIControl.State.normal)
            sender.backgroundColor = #colorLiteral(red: 0.2830694318, green: 0.4954899549, blue: 0.6407209039, alpha: 1)
        } else {
            sender.setTitle(title, for: UIControl.State.normal)
            sender.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        flipCount += 1
        ====================================
        */
        
        /* 第二種寫法 : 使用 currentAttributedTitle
         emoji 的大小在每次 touchCard
         後都會設定 attributes 使其 size 為 35
        ====================================
         var title = ""
         // 確保 titleLable 不會是 nil，用 title 取出
         if let tit = sender.titleLabel!.text {
             title = tit
         }
         
        if sender.currentAttributedTitle == nil {
            let message = NSAttributedString(string: title, attributes: attribute)
            sender.setAttributedTitle(message, for: UIControl.State.normal)
        }
        if sender.currentAttributedTitle!.string == title{
            let message = NSAttributedString(string: "", attributes: attribute)
            sender.setAttributedTitle(message, for: UIControl.State.normal)
            sender.backgroundColor = #colorLiteral(red: 0.2830694318, green: 0.4954899549, blue: 0.6407209039, alpha: 1)
        } else {
            let message = NSAttributedString(string: title, attributes: attribute)
            sender.setAttributedTitle(message, for: UIControl.State.normal)
            sender.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
         ====================================
         */

        game.flipCount += 1
        flipCountLabel.attributedText = game.updateFlipCountLable()
    }
    
    func updateViewFromModel() {
        let font = UIFont.systemFont(ofSize: 35)
        let attribute = [NSAttributedString.Key.font : font]
        for index in cardsButton.indices {
            let button = cardsButton[index]
            let card = game.cards[index]
            if !card.isFaceUp {

                let message = NSAttributedString(string: "?", attributes: attribute)
                button.setAttributedTitle(message, for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0.2830694318, green: 0.4954899549, blue: 0.6407209039, alpha: 1)
            } else {
                if card.isMatched {
                    let message = NSAttributedString(string: getEmoji(at: card), attributes: attribute)
                    button.setAttributedTitle(message, for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 0.2830694318, green: 0.4954899549, blue: 0.6407209039, alpha: 0.7047193878)
                    button.isEnabled = false
                } else {
                    let message = NSAttributedString(string: getEmoji(at: card), attributes: attribute)
                    button.setAttributedTitle(message, for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    
                }
            }
        }
    }
    
    
    @IBAction func reset(_ sender: UIButton) {
        /*
         reset cards all flip down
         */
        let font = UIFont.systemFont(ofSize: 35)
        let attribute = [NSAttributedString.Key.font : font]
        for i in 0...15 {
            let message = NSAttributedString(string: "?", attributes: attribute)
            cardsButton[i].setAttributedTitle(message, for: UIControl.State.normal)
            cardsButton[i].backgroundColor = #colorLiteral(red: 0.2830694318, green: 0.4954899549, blue: 0.6407209039, alpha: 1)
            cardsButton[i].isEnabled = true
            game.cards[i].isFaceUp = false
            game.cards[i].isMatched = false
        }
        /* reset flip count = 0*/
        game.flipCount = 0
        flipCountLabel.attributedText = game.updateFlipCountLable()
        /* shuffle the sort of cardsButton and emojiChoices */
        emojiChoices.shuffle()
        cardsButton.shuffle()
        
    }
    
    
    @IBAction func flipAll(_ sender: Any) {
        let font = UIFont.systemFont(ofSize: 35)
        let attribute = [NSAttributedString.Key.font : font]
        if !isFlipAll {
            game.flipCount = 0
            flipCountLabel.attributedText = game.updateFlipCountLable()
            for index in cardsButton.indices {
                let card = game.cards[index]
                let message = NSAttributedString(string: getEmoji(at: card), attributes: attribute)
                cardsButton[index].setAttributedTitle(message, for: UIControl.State.normal)
                cardsButton[index].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cardsButton[index].isEnabled = false
                game.cards[index].isFaceUp = true
            }
        } else {
            for index in cardsButton.indices {
                let message = NSAttributedString(string: "?", attributes: attribute)
                cardsButton[index].setAttributedTitle(message, for: UIControl.State.normal)
                cardsButton[index].backgroundColor = #colorLiteral(red: 0.2830694318, green: 0.4954899549, blue: 0.6407209039, alpha: 1)
                game.cards[index].isFaceUp = false
                game.cards[index].isMatched = false
                cardsButton[index].isEnabled = true
            }
            emojiChoices.shuffle()
            cardsButton.shuffle()
        }
        isFlipAll = !isFlipAll
    }
}

