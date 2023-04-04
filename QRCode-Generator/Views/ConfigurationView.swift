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
    @State private var pickedImageData: Data?

    @ObservedObject var colorViewModel = ColorViewModel()

    private let configurationHelper = ConfigurationHelper()

    var body: some View {
        VStack {
            colorPickerView

            iconAndIconSizeSelectorView

            previewQRCodeView

            cancelAndSaveSettingsView
        }.onAppear {
            colorViewModel.pickedColor = configurationHelper.getColor()
            pickedImageData = configurationHelper.getIconData()
            iconSize = configurationHelper.getIconSize().width
        }
        .frame(width: 320)
    }

    var colorPickerView: some View {
        GroupBox {
            Text("Color")
                .font(.title)

            HStack {
                RoundedRectangle(cornerSize: CGSize(width: 4, height: 4))
                    .fill(Color(nsColor: NSColor(fromHex: colorViewModel.pickedColor)))
                    .frame(width: 60, height: 40)
                    .border(.primary, width: 2)

                TextField("Color Hex:", text: $colorViewModel.pickedColor)
            }.padding(.horizontal)
        }
    }

    var iconAndIconSizeSelectorView: some View {
        GroupBox {
            Text("Icon")
                .font(.title)

            HStack {
                Image(nsImage: NSImage(data: pickedImageData ?? Data()) ?? NSImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .border(.primary, width: 2)
                    .padding(.horizontal)

                Button("Select Icon") {
                    let openPanel = NSOpenPanel()
                    openPanel.prompt = "Select File"
                    openPanel.allowsMultipleSelection = false
                    openPanel.canChooseDirectories = false
                    openPanel.canCreateDirectories = false
                    openPanel.canChooseFiles = true
                    openPanel.allowedContentTypes = [.png, .jpeg]
                    openPanel.begin { (result) -> Void in
                        if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                            if let openPanelURL = openPanel.url {
                                if let imageData = try? Data(contentsOf: openPanelURL) {
                                    pickedImageData = imageData
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)

                if NSImage(data: pickedImageData ?? Data()) != nil {
                    Button(role: .destructive, action: {
                        configurationHelper.deleteIcon()
                        pickedImageData = nil
                    }, label: {
                        Image(systemName: "trash")
                    })
                }

                Spacer()
            }

            if NSImage(data: pickedImageData ?? Data()) != nil {
                Slider(value: $iconSize, in: 10...100)
                    .padding(.horizontal)
            }
        }
    }

    var previewQRCodeView: some View {
        GroupBox {
            if let image = QRCodeGenerator.previewConfigQRCode(
                content: "www.google.com",
                tintColor: NSColor(fromHex: colorViewModel.pickedColor),
                logo: NSImage(data: pickedImageData ?? Data()),
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
                    showingSettings = false
                } label: {
                    Text("Cancel")
                }
                .padding()
                
                Spacer()
                
                Button("Save") {
                    configurationHelper.saveIconData(pickedImageData)
                    configurationHelper.saveColor(colorViewModel.pickedColor)
                    configurationHelper.saveIconSize(NSSize(width: iconSize, height: iconSize))
                    showingSettings = false
                    
                    if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
                        appDelegate.qrCodeViewModel.reset()
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
    }
}
