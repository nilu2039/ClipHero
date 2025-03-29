//
//  ClipboardHistoryModel.swift
//  ClipHero
//
//  Created by Nilanjan Mandal on 16/03/25.
//

import Foundation
import SwiftUI

struct ClipboardContent: Identifiable {
    let id = UUID()
    var txt: String
}

class ClipboardHistoryModel: Identifiable, ObservableObject {
    @Published var clipboardContents = [ClipboardContent]()

    init() {
        self.startClipboardMonitoring()
    }

    func startClipboardMonitoring() {
        var lastChangeCount = NSPasteboard.general.changeCount

        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            let currentChangeCount = NSPasteboard.general.changeCount
            if lastChangeCount != currentChangeCount {
                lastChangeCount = currentChangeCount
                if let string = NSPasteboard.general.string(forType: .string) {
                    DispatchQueue.main.async {
                        if self.clipboardContents.count >= 50 {
                            self.clipboardContents.removeLast()
                        }
                        self.clipboardContents.insert(ClipboardContent(txt: string), at: 0)
                    }
                }
            }
        }
    }

    func copyToClipboard(_ clipboardContent: ClipboardContent) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(clipboardContent.txt, forType: .string)
        self.clipboardContents.removeAll { $0.id == clipboardContent.id }
    }

    func clearContents() {
        self.clipboardContents.removeAll()
    }
}
