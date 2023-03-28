//
//  NSImage+Properties.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 28/03/23.
//

import Cocoa

extension NSImage {
    var height: CGFloat {
        return size.height
    }
    
    var width: CGFloat {
        return size.width
    }
    
    var png: Data? {
        if let tiff = self.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
            return tiffData.representation(using: .png, properties: [:])
        }
        
        return nil
    }
    
    func savePngTo(url: URL) throws {
        if let png {
            try png.write(to: url, options: .atomicWrite)
        } else {
            throw NSImageExtensionError.unwrappingPNGRepresentationFailed
        }
    }
}

enum NSImageExtensionError: Error {
    case unwrappingPNGRepresentationFailed
}
