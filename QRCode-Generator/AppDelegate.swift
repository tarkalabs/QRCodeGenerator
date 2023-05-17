//
//  AppDelegate.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 21/03/23.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var popover = NSPopover()
    private let timerManager = TimerManager()
    private var menu: NSMenu!
    
    let qrCodeViewModel = QRCodeViewModel()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupMacMenu()

        let statusBarMenu = NSMenu(title: "")
        
        statusBarMenu.addItem(
            withTitle: Strings.quitApplication,
            action: #selector(quitApplication),
            keyEquivalent: "q")

        // Setting menu
        menu = statusBarMenu
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(detachedWindowWillClose(notification:)),
            name: NSPopover.willCloseNotification,
            object: popover
        )
    }
    
    @objc private func detachedWindowWillClose(notification: NSNotification) {
        timerManager.stopTimer()
    }

    @objc private func quitApplication(_ sender: NSMenu) {
        // (save currently generated qrcodes)
        NSApplication.shared.terminate(self)
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        true
    }
    
    func updateColor() {
        popover.contentViewController?.view.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
    }

    private func setupMacMenu() {
        popover.animates = true
        popover.behavior = .transient

        popover.contentViewController = NSHostingController(rootView: QRCodeView(viewModel: qrCodeViewModel))
        updateColor()
        popover.contentViewController?.view.window?.makeKey()

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let menuButton = statusItem?.button {
            menuButton.image = NSImage(systemSymbolName: ImageConstants.qrcode, accessibilityDescription: nil)
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
            popover.performClose(sender)
        } else {
            qrCodeViewModel.refresh()

            timerManager.startTimer { timer in
                self.qrCodeViewModel.refresh()
            }

            popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
        }
    }
}
