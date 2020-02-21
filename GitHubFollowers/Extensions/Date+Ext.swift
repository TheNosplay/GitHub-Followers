//
//  Date+Ext.swift
//  GitHubFollowers
//
//  Created by Federico Nellen on 18.02.20.
//

import Foundation

extension Date {
    
    func converteToMonthYearFormat()-> String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM yyyy"
        return dateformatter.string(from: self)
    }
    
}
