//
//  QRCodeGenerator.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 28/03/23.
//

import CoreImage.CIFilterBuiltins
import Cocoa

class QRCodeGenerator {
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    func previewConfigQRCode(content: String, tintColor: NSColor? = nil, logo: NSImage? = nil, iconSize: NSSize? = nil) -> NSImage? {
        getQRCodeImage(content: content, tintColor: tintColor, logo: logo, iconSize: iconSize, useConfig: false)
    }

    func getQRCodeImage(
        content: String,
        tintColor: NSColor? = nil,
        logo: NSImage? = nil,
        iconSize: NSSize? = nil,
        useConfig: Bool = true
    ) -> NSImage? {
        let configurationHelper = ConfigurationHelper()

        var tintColor = tintColor

        let savedColor = configurationHelper.getColor()

        if !savedColor.isEmpty && useConfig {
            tintColor = NSColor(fromHex: savedColor)
        }

        var logo = logo

        if useConfig {
            logo = NSImage(data: configurationHelper.getIconData())
        }
        
        var iconSize = iconSize
        
        if useConfig {
            iconSize = configurationHelper.getIconSize()
        }

        let data = Data(content.utf8)
        filter.setValue(data, forKey: CIImage.Constants.inputMessage)

        var outputImage: CIImage?

        let qrTransform = CGAffineTransform(scaleX: 12, y: 12)
        outputImage = filter.outputImage?.transformed(by: qrTransform)

        if let tintColor {
            outputImage = outputImage?.tinted(using: tintColor)
        }

        if let logo,
           let iconSize,
            let resizedLogo = logo.resizeMaintainingAspectRatio(withSize: iconSize) {
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
