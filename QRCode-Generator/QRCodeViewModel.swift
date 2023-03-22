//
//  QRCodeViewModel.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 21/03/23.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

class QRCodeViewModel: ObservableObject {
    @Published var qrCodeImage: NSImage?
    var isSuccess = false

    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    private var lastValidURL: String?

    init() {
        refresh()
   }

    func refresh() {
        let pasteBoardItems = NSPasteboard.general.pasteboardItems ?? []
        var urlString = ""

        for item in pasteBoardItems {
            if let string = item.string(forType: .string) {
                urlString = string.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }

        if lastValidURL != urlString {
            qrCodeImage = getQRCodeImage(urlString)
        }
    }

    private func getQRCodeImage(_ content: String) -> NSImage {
        isSuccess = false

        guard content.isValidURL else {
            return NSImage(systemSymbolName: "xmark.circle", accessibilityDescription: nil) ?? NSImage()
        }

        lastValidURL = content

        let data = Data(content.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            isSuccess = true
            return NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))
        }

        return NSImage(systemSymbolName: "xmark.circle", accessibilityDescription: nil) ?? NSImage()
    }
}
