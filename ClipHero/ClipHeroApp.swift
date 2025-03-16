//
//  ClipHeroApp.swift
//  ClipHero
//
//  Created by Nilanjan Mandal on 16/03/25.
//

import SwiftUI

@main
struct ClipHeroApp: App {
    @StateObject private var clipboardHistory = ClipboardHistoryModel()
    
    var body: some Scene {
        MenuBarExtra("ClipHerolist.bullet.clipboard", systemImage: "list.bullet.clipboard") {
            ContentView(clipboardHistory: clipboardHistory)
        }
        .menuBarExtraStyle(.menu)
    }
}
