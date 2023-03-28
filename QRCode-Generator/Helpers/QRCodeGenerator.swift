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
    
    static func getQRCodeImage(_ content: String, _ upscaled: Bool, _ tintColor: NSColor? = nil, _ logo: NSImage? = nil) -> NSImage? {
        let configurationHelper = ConfigurationHelper()
        
        var tintColor = tintColor

        let savedColor = configurationHelper.getSavedColor()
        if !savedColor.isEmpty {
            tintColor = NSColor(fromHex: savedColor)
        }
        
        let logo = logo ?? NSImage(data: configurationHelper.getIconData())
        
        let data = Data(content.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        var outputImage: CIImage?
        
        let qrTransform = CGAffineTransform(scaleX: 12, y: 12)
        outputImage = upscaled ? filter.outputImage?.transformed(by: qrTransform) : filter.outputImage
        
        if let tintColor {
            outputImage = outputImage?.tinted(using: tintColor)
        }
        
        if let logo {
            var imageRect = CGRect(x: 0, y: 0, width: logo.size.width, height: logo.size.height)
            
            if let imageRef = logo.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) {
                outputImage = outputImage?.combined(with: CIImage(cgImage: imageRef))
            }
        }
        
        if let outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))
        }
        
        return nil
    }
}
