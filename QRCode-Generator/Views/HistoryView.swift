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
    @State var showPreviewUrl: String?
    
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
                                if showPreviewUrl == entry {
                                    showPreviewUrl = nil
                                } else {
                                    showPreviewUrl = entry
                                }
                            }, label: {
                                if showPreviewUrl == entry {
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
                        
                        if let showPreviewUrl,
                           let qrCodeImage = QRCodeGenerator.getQRCodeImage(showPreviewUrl, true),
                           showPreviewUrl == entry {
                            
                            Divider()
                            
                            Image(nsImage: qrCodeImage)
                                .resizable()
                                .interpolation(.none)
                                .scaledToFit()
                                .onDrag {
                                    let fileURL = FileManager.sharedContainerURL?.appendingPathComponent("qrCode.png")
                                    // I extended `URL`, feel free to create file in your own way
                                    
                                    do {
                                        try qrCodeImage.savePngTo(url: fileURL!)
                                    } catch {
                                        print (error)
                                    }
                                    
                                    return NSItemProvider(item: fileURL! as NSSecureCoding, typeIdentifier: UTType.fileURL.identifier)
                                }
                        }
                    }
                }
            }
        }
        .frame(width: 400, height: 600)
    }
}
