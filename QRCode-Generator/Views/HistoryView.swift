//
//  HistoryView.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 28/03/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct HistoryView: View {
    @ObservedObject var historyViewModel: HistoryViewModel
    @Binding var showingHistory: Bool
    @State var currentPreviewURL: String?
    
    var body: some View {
        VStack(alignment: .trailing) {
            Button(action: {
                showingHistory = false
            }, label: {
                Image(systemName: "xmark.circle.fill")
            })
            .font(.title2)
            .buttonStyle(.borderless)
            .padding()
            
            List() {
                ForEach(historyViewModel.history, id: \.self) { entry in
                    VStack {
                        HStack {
                            Text(entry)
                            
                            Spacer()
                            
                            Button(action: {
                                if currentPreviewURL == entry {
                                    currentPreviewURL = nil
                                } else {
                                    currentPreviewURL = entry
                                }
                            }, label: {
                                if currentPreviewURL == entry {
                                    Image(systemName: "eye.slash.fill")
                                } else {
                                    Image(systemName: "eye")
                                }
                            })
                            
                            Button(role: .destructive, action: {
                                if let selectionIndex = historyViewModel.history.firstIndex(of: entry) {
                                    historyViewModel.delete(selectionIndex)
                                }
                            }, label: {
                                Image(systemName: "trash")
                            })
                        }
                        
                        if let currentPreviewURL,
                           let qrCodeImage = QRCodeGenerator.getQRCodeImage(content: currentPreviewURL),
                           currentPreviewURL == entry {
                            
                            Divider()
                            
                            Image(nsImage: qrCodeImage)
                                .resizable()
                                .interpolation(.none)
                                .scaledToFit()
                                .onDrag {
                                    TemporaryQRCodeExporter.exportQRCodeImage(qrCodeImage)
                                    
                                    return NSItemProvider(item: FileManager.temporaryExportPath as NSSecureCoding, typeIdentifier: UTType.fileURL.identifier)
                                }
                        }
                    }
                }
            }
        }
        .frame(width: 400, height: 600)
    }
}
