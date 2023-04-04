//
//  String+IsValidColor.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 04/04/23.
//

import Foundation

extension String {
    var isValidColor: Bool {
        let colorString = first == Character("#")
            ? String(self.dropFirst())
            : self
        
        let colorRegex = "^([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$"
        let colorPred = NSPredicate(format:"SELF MATCHES %@", colorRegex)
        
        return colorPred.evaluate(with: colorString)
    }
}
