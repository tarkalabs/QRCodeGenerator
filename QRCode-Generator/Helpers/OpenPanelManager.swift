//
//  OpenPanelManager.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 17/05/23.
//

import Cocoa

class OpenPanelManager {
    // https://ourcodeworld.com/articles/read/1117/how-to-implement-a-file-and-directory-picker-in-macos-using-swift-5
    static func showPanel(image: NSImage, url: String) {
        let dialog = NSOpenPanel()

        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.allowsMultipleSelection = false
        dialog.canChooseFiles = false
        dialog.canChooseDirectories = true

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            if let pickedPath = dialog.urls.first {
                let filePath = pickedPath.appendingPathComponent(FileManager.getFileName(for: url))
                
                do {
                    try image.savePngTo(url: filePath)
                } catch {
                    print (error)
                }
            }
        } else {
            return
        }
    }
}

