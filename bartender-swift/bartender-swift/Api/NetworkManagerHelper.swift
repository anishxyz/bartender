//
//  NetworkManagerHelper.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 12/27/23.
//

import Foundation

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSX"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}
