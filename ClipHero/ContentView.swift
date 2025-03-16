//
//  ContentView.swift
//  ClipHero
//
//  Created by Nilanjan Mandal on 16/03/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var clipboardHistory: ClipboardHistoryModel
    var body: some View {
        VStack {
            Text("Clipboard Contents: ")
                .font(.headline)
            
            ForEach(clipboardHistory.clipboardContents) { content in
                Button(action: {
                    clipboardHistory.copyToClipboard(content)
                }) {
                    Text(content.txt)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(PlainButtonStyle())
                
            }
            Divider()
            Button("Quit", systemImage: "power") {
                   NSApplication.shared.terminate(nil)
            }
            .labelStyle(.titleAndIcon)
            
        }
        .padding()
    }
}

#Preview {
    ContentView(clipboardHistory: ClipboardHistoryModel())
}
