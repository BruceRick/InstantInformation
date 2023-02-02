//
//  InstantInformationApp.swift
//  InstantInformation
//
//  Created by Bruce Rick on 2022-12-31.
//

import ComposableArchitecture
import SwiftUI

@main
struct InstantInformationApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(
              store: Store(
                initialState: Root.State(),
                reducer: Root()
                    .signpost()
                    ._printChanges()
              )
            )
        }
    }
}
