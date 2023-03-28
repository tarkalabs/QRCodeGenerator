//
//  HistoryViewModel.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 28/03/23.
//

import SwiftUI

class HistoryViewModel: ObservableObject {
    @Published var history: [String] = []
    
    private let historyPlistName = "History.plist"
    private var historyPath: URL? {
        FileManager.sharedContainerURL?.appendingPathComponent(historyPlistName)
    }
    
    init() {
        history = readHistory()
    }
    
    func delete(_ index: Int) {
        guard let historyPath else {
            return
        }
        
        var historyFromDisk = readHistory()
        
        if !historyFromDisk.isEmpty {
            historyFromDisk.remove(at: index)
        }
                
        history = historyFromDisk
        
        let mutableArray = NSMutableArray(array: historyFromDisk)

        do {
            try mutableArray.write(to: historyPath)
        } catch {
            print (error)
        }
    }

    func writeToHistory(_ content: String) {
        guard let historyPath else {
            return
        }

        let historyFromDisk = readHistory()

        if historyFromDisk.isEmpty {
            history = [content]
        } else if content != historyFromDisk[0] {
            history = [content] + historyFromDisk
        }

        let mutableArray = NSMutableArray(array: history)

        do {
            try mutableArray.write(to: historyPath)
        } catch {
            print (error)
        }
    }
    
    func readHistory() -> [String] {
        guard let historyPath else {
            return []
        }
        
        return (NSMutableArray(contentsOf: historyPath) as? [String]) ?? []
    }
}
