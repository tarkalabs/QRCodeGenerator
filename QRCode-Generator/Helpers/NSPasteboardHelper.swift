//
//  NSPasteBoard+LatestContent.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 28/03/23.
//

import Cocoa

class NSPasteboardHelper {
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
}
