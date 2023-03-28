//
//  CIImage+GetTintWithIcon.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 28/03/23.
//

import CoreImage.CIFilterBuiltins
import Cocoa

extension CIImage {
    private var transparent: CIImage? {
        inverted?.blackTransparent
    }

    private var inverted: CIImage? {
        guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else {
            return nil
        }

        invertedColorFilter.setValue(self, forKey: "inputImage")
        
        return invertedColorFilter.outputImage
    }
    
    private var blackTransparent: CIImage? {
        guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else {
            return nil
        }
        
        blackTransparentFilter.setValue(self, forKey: "inputImage")
        return blackTransparentFilter.outputImage
    }
}

extension CIImage {
    /// Add tint to QRCode.
    func tinted(using color: NSColor) -> CIImage? {
        guard
            let transparentQRImage = transparent,
            let filter = CIFilter(name: "CIMultiplyCompositing"),
            let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }

        let ciColor = CIColor(color: color)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter.outputImage

        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)

        return filter.outputImage!
    }
    
    /// Add icon to center of QRCode.
    func combined(with image: CIImage) -> CIImage? {
        guard let combinedFilter = CIFilter(name: "CISourceOverCompositing") else {
            return nil
        }
        
        let centerTransform = CGAffineTransform(translationX: extent.midX - (image.extent.size.width / 2), y: extent.midY - (image.extent.size.height / 2))
        combinedFilter.setValue(image.transformed(by: centerTransform), forKey: "inputImage")
        combinedFilter.setValue(self, forKey: "inputBackgroundImage")
        
        return combinedFilter.outputImage!
    }
}
