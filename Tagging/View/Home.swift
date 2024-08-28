//
//  Home.swift
//  Tagging
//
//  Created by Tes on 28/08/2024.
//

import SwiftUI

struct Home: View {
    @State var text = ""
    @State var tags: [Tag] = []
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack {
            Text("Filter \nMenus")
                .font(.system(size: 35, weight: .bold))
                .foregroundColor(Color(.white))
                .frame(maxWidth: .infinity, alignment: .leading)
            // Custom tag view
            TagView(maxLimit: 150, tags: $tags)
            // Default height
                .frame(height: 280)
                .padding(.top, 20)
            
            // TextField
            TextField("apple", text: $text)
                .font(.title3)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color(.green).opacity(0.2), lineWidth: 1)
                )
            // Setting only textfield as dark ...
                .environment(\.colorScheme, .dark)
                .padding(.vertical, 20)
            
            // Button
            Button{
                addTag(tags: tags, text:  text, fontSize:  16, maxLimit: 150) { alert, tag in
                    if alert {
                        showAlert.toggle()
                    } else {
                        tags.append(tag)
                        text = ""
                    }
                }
            } label: {
                Text("Add Tag")
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 45)
                    .background(Color(.white))
                    .cornerRadius(12)
            }
            .disabled(text == "")
            .opacity(text == "" ? 0.6 : 1)
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            Color(.blue)
                .ignoresSafeArea()
        )
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Error"), message: Text("Tag limit exceeded, try to delete one to add a new one."), dismissButton: .destructive(Text("Ok")))
        })
    }
}

#Preview {
    Home()
}
