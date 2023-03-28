//
//  QRCodeGenerator.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 21/03/23.
//

import Combine
import Foundation

class QRCodeViewModel: ObservableObject {
    @Published var qrCodeImageData: Data?
    var isSuccess = false
    let historyManager = HistoryViewModel()
    var lastValidURL: String?

    init() {
        refresh()
   }

    func refresh() {
        let urlString = NSPasteboardHelper.getRecentURLContent()

        if lastValidURL != urlString {
            qrCodeImageData = getQRCodeImage(urlString)
        }
    }
    
    func reset() {
        lastValidURL = nil
    }

    private func getQRCodeImage(_ content: String) -> Data? {
        isSuccess = false

        guard content.isValidURL else {
            lastValidURL = nil
            return nil
        }

        lastValidURL = content

        if let qrcodeImage = QRCodeGenerator.getQRCodeImage(content: content) {
            isSuccess = true

            historyManager.writeToHistory(content)
            return qrcodeImage.png
        }

        return nil
    }
}
