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
    var shouldUpdateURL = true

    init() {
        refresh()
   }

    func refresh() {
        let urlString = NSPasteboardHelper().getRecentURLContent()

        if lastValidURL != urlString, urlString.isValidURL, shouldUpdateURL {
            qrCodeImageData = getQRCodeImage(urlString)
        }
    }

    func forceRefresh() {
        if let lastValidURL {
            qrCodeImageData = getQRCodeImage(lastValidURL)
        }
    }

    private func getQRCodeImage(_ content: String) -> Data? {
        isSuccess = false

        lastValidURL = content

        if let qrcodeImage = QRCodeGenerator().getQRCodeImage(content: content) {
            isSuccess = true

            historyManager.writeToHistory(content)
            return qrcodeImage.png
        }

        return nil
    }
}
