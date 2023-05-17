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
                (NSApplication.shared.delegate as? AppDelegate)?.qrCodeViewModel.shouldUpdateURL.toggle()
                
                showingHistory = false
            }, label: {
                Image(systemName: ImageConstants.close)
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
                                    Image(systemName: ImageConstants.hide)
                                } else {
                                    Image(systemName: ImageConstants.show)
                                }
                            })
                            
                            Button(role: .destructive, action: {
                                if let selectionIndex = historyViewModel.history.firstIndex(of: entry) {
                                    historyViewModel.delete(selectionIndex)
                                }
                            }, label: {
                                Image(systemName: ImageConstants.trash)
                            })
                        }
                        
                        if let currentPreviewURL,
                           let qrCodeImage = QRCodeGenerator().getQRCodeImage(content: currentPreviewURL),
                           currentPreviewURL == entry {
                            
                            Divider()
                            
                            Image(nsImage: qrCodeImage)
                                .resizable()
                                .interpolation(.none)
                                .scaledToFit()
                                .onDrag {
                                    TemporaryQRCodeExporter().exportQRCodeImage(qrCodeImage, currentPreviewURL)
                                    
                                    return NSItemProvider(item: FileManager.getExportPath(currentPreviewURL) as NSSecureCoding, typeIdentifier: UTType.fileURL.identifier)
                                }
                                .contextMenu {
                                    Button {
                                        TemporaryQRCodeExporter().exportQRCodeImage(qrCodeImage, currentPreviewURL)
                                        
                                        OpenPanelManager.showPanel(image: qrCodeImage, url: currentPreviewURL)
                                    } label: {
                                        Label("Save", systemImage: "square.and.arrow.down")
                                    }
                                }
                        }
                    }
                }
            }
        }
        .frame(width: 400, height: 600)
    }
}
