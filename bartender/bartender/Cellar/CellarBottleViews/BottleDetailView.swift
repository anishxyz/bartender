//
//  BottleDetailView.swift
//  bartender
//
//  Created by Anish Agrawal on 5/19/24.
//

import SwiftUI

struct BottleDetailView: View {
    
    @Binding var bottle: Bottle
    @State private var isEditing = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if isEditing {
                EditBottleView(bottle: $bottle)
            } else {
                Text(bottle.name)
                    .bold()
                    .font(.title)
                if let info = bottle.info {
                    Text(info)
                        .padding(.bottom)
                }
                VStack(spacing: 8) {
                    HStack {
                        Text("Type:")
                        Spacer()
                        HStack {
                            Image(bottle.type.filledSymbolName)
                            Text(bottle.type.rawValue)
                                .lineLimit(1)
                        }
                        .tagStyle(bgc: bottle.type.color)
                    }
                    HStack {
                        Text("Quantity:")
                        Spacer()
                        Text("\(bottle.qty)")
                            .tagStyle(bgc: Color.secondary)
                            .lineLimit(1)
                    }
                    HStack {
                        Text("Bar:")
                        Spacer()
                        if let bar = bottle.bar {
                            Text("\(bar.name)")
                                .tagStyle(bgc: .blue)
                                .lineLimit(1)
                        }
                    }
                    HStack {
                        Text("Price:")
                        Spacer()
                        if let price = bottle.price {
                            Text(String(format: "$%.2f", price))
                                .tagStyle(bgc: Color.secondary)
                                .lineLimit(1)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(UIColor.systemGroupedBackground))
                )
            }
            Spacer()
            HStack {
                Button(action: {
                    isEditing.toggle()
                }, label: {
                    HStack {
                        Image(systemName: isEditing ? "eye" : "pencil")
                        Text(isEditing ? "Preview" : "Edit")
                    }
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                })
                .buttonStyle(.bordered)
                .tint(.orange)
                
                Spacer()
                
                if !isEditing {
                    Text("Created on: \(formattedDate(bottle.created_at))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .padding(.top)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
}
