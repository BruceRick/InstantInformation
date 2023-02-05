//
//  TextInput.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-02.
//

import SwiftUI

struct TextInput: View {
    var placeHolder: String = ""
    let text: Binding<String>
    var isSecure: Bool = false
    @State private var showPassword: Bool = false
    @FocusState private var focused: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            textFieldContainer
                .font(.subheadline)
                .frame(height: 44)
                .padding(.horizontal, 14)
                .background(.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(focused ? .blue : Color(.systemGray3), lineWidth: focused ? 4 : 2)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.top, 7)
            if !text.wrappedValue.isEmpty {
                Text(placeHolder)
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundColor(focused ? .blue : .gray)
                    .padding(.horizontal, 4)
                    .background(.ultraThickMaterial)
                    .padding(.leading, 10)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.default, value: text.wrappedValue)
    }

    @ViewBuilder
    var textField: some View {
        if isSecure && !showPassword {
            SecureField(placeHolder, text: text)
                .focused($focused)
        } else {
            TextField(placeHolder, text: text)
                .focused($focused)
        }
}

    var textFieldContainer: some View {
        ZStack(alignment: .trailing) {
            textField
                .padding(.trailing, 32)
                .fontWeight(.medium)
                .foregroundColor(focused ? .blue : .gray)
                .frame(maxWidth: .infinity)
            if isSecure {
                Button(action: {
                    showPassword.toggle()
                }) {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                        .accentColor(.gray)
                }
                .frame(height: 32)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}
