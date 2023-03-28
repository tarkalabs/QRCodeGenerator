//
//  AppDelegate.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 21/03/23.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover = NSPopover()
    let qrCodeViewModel = QRCodeViewModel()

    var timer: Timer?
    var menu: NSMenu!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupMacMenu()

        let statusBarMenu = NSMenu(title: "")
        
        statusBarMenu.addItem(
            withTitle: "Quit application",
            action: #selector(quitApplication),
            keyEquivalent: "q")

        // Setting menu
        menu = statusBarMenu
    }

    @objc private func quitApplication(_ sender: NSMenu) {
        // (save currently generated qrcodes)
        NSApplication.shared.terminate(self)
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        true
    }

    private func setupMacMenu() {
        popover.animates = true
        popover.behavior = .transient

        popover.contentViewController = NSHostingController(rootView: QRCodeView(viewModel: qrCodeViewModel))
        popover.contentViewController?.view.window?.makeKey()

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let menuButton = statusItem?.button {
            menuButton.image = NSImage(systemSymbolName: "qrcode", accessibilityDescription: nil)
            menuButton.action = #selector(menuButtonAction(_:))
            menuButton.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }

    @objc private func menuButtonAction(_ sender: NSStatusBarButton) {
        guard NSApp.currentEvent?.type == .leftMouseUp else {
            statusItem?.popUpMenu(menu)
            return
        }

        if popover.isShown {
            timer?.invalidate()
            timer = nil
            popover.performClose(sender)
        } else {
            qrCodeViewModel.refresh()

            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
                self.qrCodeViewModel.refresh()
            }

            popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
        }
    }
}

