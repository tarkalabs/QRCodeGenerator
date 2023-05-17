//
//  QRCodeView.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 21/03/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct QRCodeView: View {
    @ObservedObject var viewModel: QRCodeViewModel
    @State var showingHistory = false
    @State var showingSettings = false
    
    var body: some View {
        VStack(alignment: .center) {
            if !viewModel.isSuccess {
                Image(systemName: ImageConstants.noImagePlaceHolder)
                    .resizable()
                    .scaledToFit()
                
                Text(Strings.copyValidURL)
                    .padding()
            }
            
            if let qrCodeImageData = viewModel.qrCodeImageData, let qrCodeImage = NSImage(data: qrCodeImageData) {
                Image(nsImage: qrCodeImage)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .contextMenu {
                        Button {
                            OpenPanelManager.showPanel(image: qrCodeImage, url: viewModel.lastValidURL ?? "")
                        } label: {
                            Label("Save", systemImage: "square.and.arrow.down")
                        }
                    }
                    .onDrag {
                        TemporaryQRCodeExporter().exportQRCodeWithString(viewModel.lastValidURL ?? "")
                                    
                        return NSItemProvider(item: FileManager.getExportPath(viewModel.lastValidURL ?? "") as NSSecureCoding, typeIdentifier: UTType.fileURL.identifier)
                    }
            }
            
            Divider()

            HStack {
                Button {
                    viewModel.shouldUpdateURL.toggle()
                    self.showingHistory.toggle()
                } label: {
                    HStack {
                        Image(systemName: ImageConstants.history)
                        
                        Text(Strings.history)
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .sheet(isPresented: $showingHistory) {
                    HistoryView(historyViewModel: viewModel.historyManager, showingHistory: $showingHistory)
                }
                
                Button {
                    viewModel.shouldUpdateURL.toggle()
                    self.showingSettings.toggle()
                } label: {
                    HStack {
                        Image(systemName: ImageConstants.settings)
                        
                        Text(Strings.settings)
                    }
                }
                .buttonStyle(.automatic)
                .padding()
                .sheet(isPresented: $showingSettings) {
                    ConfigurationView(showingSettings: $showingSettings)
                }
            }
        }
        .frame(width: 320, height: 400)
    }
}
