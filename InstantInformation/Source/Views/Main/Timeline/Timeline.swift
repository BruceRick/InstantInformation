//
//  Timeline.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-03.
//

import ComposableArchitecture

struct Timeline: ReducerProtocol {
    struct State: Equatable { }

    enum Action { }

    var body: some ReducerProtocol<State, Action> {
        Reduce { _, _ in
            return .none
        }
    }
}
