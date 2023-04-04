//
//  QRCodeExporter.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 04/04/23.
//

import Cocoa

/// Saves a temporary image at `FileManager.temporaryExportPath`.
class TemporaryQRCodeExporter {
    private init() { }

    static func exportQRCodeWithString(_ content: String) {
        do {
            try QRCodeGenerator.getQRCodeImage(content: content)?.savePngTo(url: FileManager.temporaryExportPath)
        } catch {
            print(error)
        }
    }

    static func exportQRCodeImage(_ content: NSImage) {
        do {
            try content.savePngTo(url: FileManager.temporaryExportPath)
        } catch {
            print(error)
        }
    }
}
