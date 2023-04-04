//
//  FileManager+TemporaryFilePath.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 04/04/23.
//

import Foundation

extension FileManager {
    private static let tempFileName = "qrCode.png"
    
    static var temporaryExportPath: URL {
        sharedContainerURL!.appendingPathComponent(tempFileName)
    }
}
