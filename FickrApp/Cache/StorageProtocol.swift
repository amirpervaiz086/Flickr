//
//  StorageProtocol.swift
//  FickrApp
//
//  Created by Amir Pervaiz on 4/9/21.
//

import Foundation

protocol ReadableProtocol {
    func fetchValue(for key: String) throws -> Data
}

protocol WritableProtocol {
    func save(value: Data, for key: String) throws
}

typealias Storage = ReadableProtocol & WritableProtocol
