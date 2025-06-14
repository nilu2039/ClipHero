//
//  ContentView.swift
//  ClipHero
//
//  Created by Nilanjan Mandal on 16/03/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var clipboardHistory: ClipboardHistoryModel
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    @Environment(\.dismiss) private var dismiss

    
    
    private var filteredClipboardContents: [ClipboardContent] {
        if searchText.isEmpty {
            return clipboardHistory.clipboardContents
        } else {
            return clipboardHistory.clipboardContents.filter { content in
                content.txt.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            Text("Clipboard History")
                .font(.headline)
                .padding(.top, 12)
                .padding(.horizontal)
            
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.system(size: 14))
                
                TextField("Search clipboard...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .focused($isSearchFocused)
                    .font(.system(size: 13))
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.system(size: 12))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(6)
            .padding(.horizontal, 12)
            .padding(.top, 8)
            
            Divider()
                .padding(.top, 8)
            
            if filteredClipboardContents.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: searchText.isEmpty ? "clipboard" : "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    Text(searchText.isEmpty ? "No clipboard history" : "No results found")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if !searchText.isEmpty {
                        Text("Try different keywords")
                            .font(.caption2)
                            .foregroundColor(.red)
                    }
                }
                .padding(.vertical, 20)
            } else {
                ScrollView {
                    LazyVStack(spacing: 1) {
                        ForEach(Array(filteredClipboardContents.enumerated()), id: \.element.id) { index, content in
                            ClipboardItemRow(
                                content: content,
                                searchText: searchText,
                                isLast: filteredClipboardContents.count - 1 == index
                            ) {
                                clipboardHistory.copyToClipboard(content)
                                dismiss()
                            }
                        }
                    }
                }
                .frame(maxHeight: 300)
            }
            
            Divider()
            
            HStack(spacing: 12) {
                Button("Clear All", systemImage: "trash") {
                    clipboardHistory.clearContents()
                    searchText = "" // Clear search when clearing contents
                }
                .labelStyle(.titleAndIcon)
                .font(.system(size: 12))
                
                Spacer()
                
                Button("Quit", systemImage: "power") {
                    NSApplication.shared.terminate(nil)
                }
                .labelStyle(.titleAndIcon)
                .font(.system(size: 12))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .frame(width: 350)
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isSearchFocused = true
            }
        }
    }
}

struct ClipboardItemRow: View {
    let content: ClipboardContent
    let searchText: String
    let isLast: Bool
    let onTap: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                        Text(content.txt)
                            .font(.system(size: 13))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                    
                    HStack {
                        Text("\(content.txt.count) chars")
                            .font(.system(size: 10))
                            .foregroundColor(.primary)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Image(systemName: "doc.on.clipboard")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(isHovered ? Color(NSColor.selectedControlColor).opacity(0.3) : Color.clear)
        )
        .onHover { hovering in
            isHovered = hovering
        }
        if !isLast{
            Divider()
        }
    }
    
//    @ViewBuilder
//    private func highlightedText(_ text: String, searchText: String) -> some View {
//        let parts = text.components(separatedBy: searchText)
//        let searchCount = parts.count - 1
//        
//        if searchCount > 0 {
//            HStack(spacing: 0) {
//                ForEach(0..<parts.count, id: \.self) { index in
//                    Text(parts[index])
//                        .foregroundColor(.primary)
//                    
//                    if index < searchCount {
//                        Text(searchText)
//                            .foregroundColor(.white)
//                            .background(Color.blue.opacity(0.8))
//                            .cornerRadius(2)
//                    }
//                }
//            }
//        } else {
//            Text(text)
//                .foregroundColor(.primary)
//        }
//    }
    
    
}

extension ClipboardContent {
    var timestamp: Date {
        Date()
    }
}

#Preview {
    ContentView(clipboardHistory: ClipboardHistoryModel())
}
