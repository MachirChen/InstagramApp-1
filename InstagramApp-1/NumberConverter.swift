//
//  NumberConverter.swift
//  InstagramApp-1
//
//  Created by Machir on 2021/9/27.
//

import Foundation

func numCoverter(_ number: Int) -> String {
    if number > 1000000 {
        let millionNumber = number / 1000000
        let thousandNumber = String(format: "%03d", (number % 1000000) / 1000)
        let lessThanNumber = String(format: "%03d", number % 1000)
        return "\(millionNumber),\(thousandNumber),\(lessThanNumber)"
    } else if number > 1000 {
        let thousandNumber = number / 1000
        let lessThanThousandNumber = String(format: "%03d", number % 1000)
        return "\(thousandNumber),\(lessThanThousandNumber)"
    } else {
        return String(number)
    }
}
