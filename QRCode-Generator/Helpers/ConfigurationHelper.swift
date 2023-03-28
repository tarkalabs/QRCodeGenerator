//
//  ConfigurationHelper.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 28/03/23.
//

import Combine
import Foundation

class ConfigurationHelper {
    private let colorFileName = "Color.txt"
    private let iconImageName = "icon"
    private let iconSize = "IconSize.txt"

    private var colorPath: URL? {
        FileManager.sharedContainerURL?.appendingPathComponent(colorFileName)
    }

    private var imagePath: URL? {
        FileManager.sharedContainerURL?.appendingPathComponent(iconImageName)
    }
    
    private var iconSizePath: URL? {
        FileManager.sharedContainerURL?.appendingPathComponent(iconSize)
    }
    
    func saveIconSize(_ size: NSSize) {
        guard let iconSizePath else {
            return
        }
        
        do {
            try (NSStringFromSize(size) as String).debugDescription.write(to: iconSizePath, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }

    func saveIcon(_ data: Data?) {
        guard let imagePath, let data else {
            return
        }
        
        do {
            try data.write(to: imagePath)
        } catch {
            print (error)
        }
    }
    
    func getIconSize() -> NSSize {
        var iconSize = NSSize()
        
        guard let iconSizePath else {
            return iconSize
        }

        do {
            let iconSizeString = try String(contentsOf: iconSizePath)
            iconSize = NSSizeFromString(iconSizeString)
        } catch {
            print (error)
        }
        
        return iconSize
    }

    func getIconData() -> Data {
        var iconData = Data()
        
        guard let imagePath else {
            return iconData
        }

        do {
            iconData = try Data(contentsOf: imagePath)
        } catch {
            print (error)
        }
        
        return iconData
    }

    func saveColor(_ color: String) {
        guard let colorPath else {
            return
        }

        do {
            try color.write(to: colorPath, atomically: true, encoding: .utf8)
        } catch {
            print (error)
        }
    }

    func getSavedColor() -> String {
        var colorString = ""
        
        guard let colorPath else {
            return colorString
        }

        do {
            colorString = try String(contentsOf: colorPath)
        } catch {
            print (error)
        }
        
        return colorString
    }
}