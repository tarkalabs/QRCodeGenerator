//
//  ConfigurationView.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 28/03/23.
//

import SwiftUI

struct ConfigurationView: View {
    @Binding var showingSettings: Bool

    @State private var iconSize: Double = 10
    @State private var pickedIconImageData: Data?

    @ObservedObject var colorViewModel = ColorViewModel()

    private let configurationHelper = ConfigurationHelper()
    
    private var qrCodeViewModel: QRCodeViewModel? {
        (NSApplication.shared.delegate as? AppDelegate)?.qrCodeViewModel
    }

    var body: some View {
        VStack {
            colorPickerView

            iconAndIconSizeSelectorView

            previewQRCodeView

            cancelAndSaveSettingsView
        }
        .onAppear {
            colorViewModel.pickedColor = configurationHelper.getColor()
            pickedIconImageData = configurationHelper.getIconData()
            iconSize = configurationHelper.getIconSize().width
        }
        .frame(width: 320)
    }
    
    var colorPickerView: some View {
        GroupBox {
            HStack {
                ColorPicker("Pick color for QR Code", selection: $colorViewModel.pickedColor)
                
                Spacer()
            }.padding(.horizontal)
        }
    }

    var iconAndIconSizeSelectorView: some View {
        GroupBox {
            HStack {
                Image(nsImage: NSImage(data: pickedIconImageData ?? Data()) ?? NSImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .border(.primary, width: 2)
                    .padding(.horizontal)

                Button(Strings.selectIcon) {
                    let openPanel = NSOpenPanel()
                    openPanel.prompt = Strings.selectFile
                    openPanel.allowsMultipleSelection = false
                    openPanel.canChooseDirectories = false
                    openPanel.canCreateDirectories = false
                    openPanel.canChooseFiles = true
                    openPanel.allowedContentTypes = [.png, .jpeg]
                    openPanel.begin { (result) -> Void in
                        if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                            if let openPanelURL = openPanel.url {
                                if let imageData = try? Data(contentsOf: openPanelURL) {
                                    pickedIconImageData = imageData
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)

                if NSImage(data: pickedIconImageData ?? Data()) != nil {
                    Button(role: .destructive, action: {
                        configurationHelper.deleteIconData()
                        pickedIconImageData = nil
                    }, label: {
                        Image(systemName: ImageConstants.trash)
                    })
                }

                Spacer()
            }

            if NSImage(data: pickedIconImageData ?? Data()) != nil {
                Slider(value: $iconSize, in: 10...100, label: { Text("Icon Size") })
                    .padding(.horizontal)
            }
        }
    }

    var previewQRCodeView: some View {
        GroupBox {
            if let image = QRCodeGenerator().previewConfigQRCode(
                content: "www.google.com",
                tintColor: NSColor(colorViewModel.pickedColor),
                logo: NSImage(data: pickedIconImageData ?? Data()),
                iconSize: NSSize(width: iconSize, height: iconSize)
            ) {
                Image(nsImage: image)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 300)
                    .border(.primary, width: 2)
            }
        }
    }

    var cancelAndSaveSettingsView: some View {
        GroupBox {
            HStack {
                Button(role: .cancel) {
                    qrCodeViewModel?.shouldUpdateURL.toggle()

                    showingSettings = false
                } label: {
                    Text(Strings.cancel)
                }
                .padding()
                
                Spacer()
                
                Button(Strings.save) {
                    configurationHelper.saveIconData(pickedIconImageData)
                    configurationHelper.saveColor(colorViewModel.pickedColor)
                    configurationHelper.saveIconSize(NSSize(width: iconSize, height: iconSize))
                    
                    qrCodeViewModel?.shouldUpdateURL.toggle()
                    qrCodeViewModel?.forceRefresh()
                    
                    showingSettings = false
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
    }
}
