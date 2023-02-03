//
//  Authentication.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-03.
//

import Foundation

public struct Authentication: Codable, Equatable {
    let accessToken: String
    let refreshToken: String
}
