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

    var body: some View {
        Group {
            Text(text.wrappedValue.isEmpty ? " " : placeHolder)
                .font(.footnote)
                .foregroundColor(Color.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
            textFieldContainer
                .font(.subheadline)
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 1)
                .frame(maxWidth: .infinity)
        }
        .animation(.default, value: text.wrappedValue)
    }

    @ViewBuilder
    var textField: some View {
        if isSecure && !showPassword {
            SecureField(placeHolder, text: text)
        } else {
            TextField(placeHolder, text: text)
        }
}

    var textFieldContainer: some View {
        ZStack(alignment: .trailing) {
            textField
                .padding(.trailing, 32)
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
