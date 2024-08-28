//
//  TagView.swift
//  Tagging
//
//  Created by Tes on 28/08/2024.
//

import SwiftUI

struct TagView: View {
    var maxLimit: Int
    var text = "Add some tags"
    @Binding var tags: [Tag]
    var fontSize: CGFloat = 16
    @Namespace var animation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(text)
                .font(.callout)
                .foregroundColor(.white)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(getRows(), id: \.self) { row in
                        HStack(spacing: 6) {
                            ForEach(row) { tag in
                                RowView(tag: tag)
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 80, alignment: .leading)
                .padding(.vertical)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color(.white).opacity(0.15), lineWidth: 1)
            )
            .animation(.easeInOut, value: tags)
            .overlay(
                Text("\(getSize(tags: tags))/\(maxLimit)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(12),
                
                alignment: .bottomTrailing
            )
        }
    }
    
    @ViewBuilder
    func RowView(tag: Tag) -> some View {
        Text(tag.text)
            .font(.system(size: fontSize))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color(.white))
            )
            .lineLimit(1)
            .foregroundColor(.blue)
        // Delete
            .contentShape(Capsule())
            .contextMenu(ContextMenu(menuItems: {
                Button("Delete") {
                    tags.remove(at: getIndex(tag: tag))
                }
            }))
            .matchedGeometryEffect(id: tag.id, in: animation)
    }
    
    func getRows() -> [[Tag]]{
        var rows: [[Tag]] = []
        var currentRow: [Tag] = []
        
        // Calculating text width
        var totalWidth: CGFloat = 0
        let screenWidth: CGFloat = UIScreen.main.bounds.width - 90

        tags.forEach { tag in
            // Updating total width
            totalWidth += (tag.size + 40)
            
            if totalWidth > screenWidth {
                // adding row in rows
                totalWidth = (!currentRow.isEmpty || rows.isEmpty ? (tag.size + 40) : 0)
                
                rows.append(currentRow)
                currentRow.removeAll()
                currentRow.append(tag)
                
            } else {
                currentRow.append(tag)
            }
        }
        
        if !currentRow.isEmpty {
            rows.append(currentRow)
            currentRow.removeAll()
        }
        return rows
        
    }
        
    func getIndex(tag: Tag) -> Int {
        let index = tags.firstIndex { currentTag in
            return tag.id == currentTag.id
        } ?? 0
        
        return index
    }
}

// Global function
func addTag(tags: [Tag], text: String, fontSize: CGFloat, maxLimit: Int, completion: @escaping(Bool, Tag) -> ()) {
    // getting text size
    let font = UIFont.systemFont(ofSize: fontSize)
    let attributes = [NSAttributedString.Key.font: font]
    let size = (text as NSString).size(withAttributes: attributes)
    let tag = Tag(text: text, size: size.width)
    if (getSize(tags: tags) + text.count) < maxLimit {
        completion(false, tag)
    } else {
        completion(true, tag)
    }
}

func getSize(tags: [Tag]) -> Int {
    var count: Int = 0
    tags.forEach { tag in
        count += tag.text.count
    }
    return count
}

#Preview {
    ContentView()
}
