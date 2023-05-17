//
//  FileManager+TemporaryFilePath.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 04/04/23.
//

import Foundation

extension FileManager {
    private static let tempFileName = "qrCode.png"
    
    static func getFileName(for url: String) -> String {
        let fileName = url.getFileName()
        
        return fileName.isEmpty ? "qrCode.png" : fileName
    }

    static func getExportPath(_ url: String = "") -> URL {
        (sharedContainerURL ?? .homeDirectory).appendingPathComponent(getFileName(for: url))
    }
}
