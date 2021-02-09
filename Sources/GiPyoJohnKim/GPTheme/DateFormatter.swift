//
//  DateFormatter.swift
//  
//
//  Created by Gi Pyo Kim on 2/8/21.
//

import Foundation

extension DateFormatter {
    static var blog: DateFormatter  = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}
