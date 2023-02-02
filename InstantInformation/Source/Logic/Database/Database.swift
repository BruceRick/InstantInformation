//
//  Database.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-02.
//

import Foundation

public struct Database {
    public enum Key: String {
        case didShowInitialAnimation
    }

    static let defaults = UserDefaults.standard
    static let encoder = JSONEncoder()
    static let decoder = JSONDecoder()

    static func set(_ value: Bool, key: Database.Key) {
        defaults.set(value, forKey: key.rawValue)
    }

    static func get(_ key: Database.Key) -> Bool {
        return defaults.bool(forKey: key.rawValue)
    }

    static func set<T: Encodable>(_ value: T?, key: Database.Key) {
        if let encoded = try? encoder.encode(value) {
            defaults.set(encoded, forKey: key.rawValue)
        }
    }

    static func get<T: Codable>(_ key: Database.Key) -> T? {
        guard let value = defaults.object(forKey: key.rawValue) as? Data else {
            return nil
        }

        return try? decoder.decode(T.self, from: value)
    }
}
