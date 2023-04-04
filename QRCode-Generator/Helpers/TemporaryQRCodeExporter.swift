//
//  QRCodeExporter.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 04/04/23.
//

import Cocoa

/// Saves a temporary image at `FileManager.temporaryExportPath`.
class TemporaryQRCodeExporter {
    func exportQRCodeWithString(_ content: String) {
        do {
            try QRCodeGenerator().getQRCodeImage(content: content)?.savePngTo(url: FileManager.temporaryExportPath)
        } catch {
            print(error)
        }
    }

    func exportQRCodeImage(_ content: NSImage) {
        do {
            try content.savePngTo(url: FileManager.temporaryExportPath)
        } catch {
            print(error)
        }
    }
}
