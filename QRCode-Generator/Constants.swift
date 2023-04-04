//
//  Constants.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 04/04/23.
//

import CoreImage.CIFilterBuiltins

extension CIImage {
    enum Constants {
        static let alphaMask = "CIMaskToAlpha"
        static let colorInvert =  "CIColorInvert"
        static let constantColorGenrator = "CIConstantColorGenerator"
        static let inputBackgroundImage = "inputBackgroundImage"
        static let inputImage = "inputImage"
        static let inputMessage = "inputMessage"
        static let multiplyComposting = "CIMultiplyCompositing"
        static let sourceOverComposting = "CISourceOverCompositing"
    }
}

enum ImageConstants {
    static let close = "xmark.circle.fill"
    static let hide = "eye.slash.fill"
    static let history = "clock"
    static let noImagePlaceHolder = "xmark.circle"
    static let qrcode = "qrcode"
    static let settings = "gearshape.fill"
    static let show = "eye"
    static let trash = "trash"
}

enum Strings {
    static let cancel = "Cancel"
    static let color = "Color"
    static let colorHex = "Color Hex:"
    static let copyValidURL = "Please copy a valid URL"
    static let history = "History"
    static let icon = "Icon"
    static let save = "Save"
    static let selectFile = "Select File"
    static let selectIcon = "Select Icon"
    static let settings = "Settings"
    static let quitApplication = "Quit application"
}
