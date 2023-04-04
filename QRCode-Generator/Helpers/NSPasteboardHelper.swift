//
//  NSPasteBoard+LatestContent.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 28/03/23.
//

import Cocoa

class NSPasteboardHelper {
    private init() { }

    static func getRecentURLContent() -> String {
        let pasteBoardItems = NSPasteboard.general.pasteboardItems ?? []
        var urlString = ""

        for item in pasteBoardItems {
            if let string = item.string(forType: .string) {
                urlString = string.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }

        return urlString
    }
    
    static func getRecentPickedColor() -> String {
        let pasteBoardItems = NSPasteboard.general.pasteboardItems ?? []
        var colorString = ""
        
        for item in pasteBoardItems {
            if let string = item.string(forType: .string), [1, 3, 4, 6, 7].contains(string.trimmingCharacters(in: .whitespacesAndNewlines).count) {
                colorString = string
            }
        }
        
        return colorString
    }
}
