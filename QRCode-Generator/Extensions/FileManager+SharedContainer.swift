//
//  FileManager+SharedContainer.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 28/03/23.
//

import Foundation

extension FileManager {
    private static let appGroupName = "546C62BX57.com.tarka.QRtist"

    static var sharedContainerURL: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)
    }
}

