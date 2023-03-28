//
//  QRCodeGenerator.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 28/03/23.
//

import CoreImage.CIFilterBuiltins
import Cocoa

class QRCodeGenerator {
    private static let context = CIContext()
    private static let filter = CIFilter.qrCodeGenerator()

    static func previewConfigQRCode(_ content: String, _ upscaled: Bool, _ tintColor: NSColor? = nil, _ logo: NSImage? = nil) -> NSImage? {
        getQRCodeImage(content, upscaled, tintColor, logo, useConfig: false)
    }

    static func getQRCodeImage(_ content: String, _ upscaled: Bool, _ tintColor: NSColor? = nil, _ logo: NSImage? = nil, useConfig: Bool = true) -> NSImage? {
        let configurationHelper = ConfigurationHelper()

        var tintColor = tintColor

        let savedColor = configurationHelper.getSavedColor()

        if !savedColor.isEmpty && useConfig {
            tintColor = NSColor(fromHex: savedColor)
        }

        var logo = logo

        if useConfig {
            logo = NSImage(data: configurationHelper.getIconData())
        }

        let data = Data(content.utf8)
        filter.setValue(data, forKey: "inputMessage")

        var outputImage: CIImage?

        let qrTransform = CGAffineTransform(scaleX: 12, y: 12)
        outputImage = upscaled ? filter.outputImage?.transformed(by: qrTransform) : filter.outputImage

        if let tintColor {
            outputImage = outputImage?.tinted(using: tintColor)
        }

        if let logo,
            let resizedLogo = logo.resizeMaintainingAspectRatio(withSize: NSSize(width: 24, height: 24)) {
            var imageRect = CGRect(x: 0, y: 0, width: resizedLogo.size.width, height: resizedLogo.size.height)

            if let imageRef = resizedLogo.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) {
                outputImage = outputImage?.combined(with: CIImage(cgImage: imageRef))
            }
        }

        if let outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))
        }

        return nil
    }
}
