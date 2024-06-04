//
//  Date+Extensions.swift
//  Movies
//
//  Created by Petro Yurkiv on 02.06.2024.
//

import Foundation

extension Date {
    static func yearString(from dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            return String(year)
        }
        return nil
    }
}
