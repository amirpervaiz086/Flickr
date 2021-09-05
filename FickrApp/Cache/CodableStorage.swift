//
//  CodableStorage.swift
//  FickrApp
//
//  Created by Amir Pervaiz on 4/9/21.
//

import Foundation

class CodableStorage {
    private let storage: Storage
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(
        storage: Storage,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) {
        self.storage = storage
        self.decoder = decoder
        self.encoder = encoder
    }

    func fetch<T: Decodable>(for key: String) throws -> T {
        let data = try storage.fetchValue(for: key)
        return try decoder.decode(T.self, from: data)
    }

    func save<T: Encodable>(_ value: T, for key: String) throws {
        let data = try encoder.encode(value)
        try storage.save(value: data, for: key)
    }
}
