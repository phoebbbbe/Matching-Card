//
//  Int.swift
//  Matching-Card
//
//  Created by 林寧 on 2023/5/12.
//

import Foundation

extension Int {
    var arc4random: Int{
        if self>0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self<0 {
            return Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
