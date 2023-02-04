//
//  Logo.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-02.
//

import SwiftUI

struct Logo: View {
    var body: some View {
        Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .padding(.top, 20)
            .padding(.bottom, 20)
    }
}
