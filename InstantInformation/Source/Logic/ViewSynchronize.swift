//
//  ViewSynchronize.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-02.
//

import ComposableArchitecture
import SwiftUI

extension View {
  func synchronize<Value>(
    _ first: Binding<Value>,
    _ second: FocusState<Value>.Binding
  ) -> some View {
    self
      .onChange(of: first.wrappedValue) { second.wrappedValue = $0 }
      .onChange(of: second.wrappedValue) { first.wrappedValue = $0 }
  }
}
