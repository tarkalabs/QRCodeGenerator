//
//  Constants.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 04/04/23.
//

import CoreImage.CIFilterBuiltins

extension CIImage {
    enum Constants {
        static let colorInvert =  "CIColorInvert"
        static let inputImage = "inputImage"
        static let alphaMask = "CIMaskToAlpha"
        static let multiplyComposting = "CIMultiplyCompositing"
        static let constantColorGenrator = "CIConstantColorGenerator"
        static let sourceOverComposting = "CISourceOverCompositing"
        static let inputBackgroundImage = "inputBackgroundImage"
    }
}
