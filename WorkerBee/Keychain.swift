//
//  Keychain.swift
//  WorkerBee
//
//  Created by nixzhu on 2018/5/3.
//  Copyright © 2018年 nixWork. All rights reserved.
//

import Foundation

public class Keychain {

    public static let shared = Keychain()

    public init() {
    }

    public enum KeychainError: Error {
        case itemNotFound
        case unexpectedItemData
        case unhandledError(status: OSStatus)
    }

    public func read(key: String) throws -> Data {
        var query = keychainQuery(key: key)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue

        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        guard status != errSecItemNotFound else { throw KeychainError.itemNotFound }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }

        guard
            let existingItem = queryResult as? [String : AnyObject],
            let data = existingItem[kSecValueData as String] as? Data
        else {
            throw KeychainError.unexpectedItemData
        }
        return data
    }

    public func save(key: String, data: Data) throws {
        do {
            try _ = read(key: key)

            var attributesToUpdate: [String: AnyObject] = [:]
            attributesToUpdate[kSecValueData as String] = data as AnyObject?

            let query = keychainQuery(key: key)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        } catch KeychainError.itemNotFound {
            var newItem = keychainQuery(key: key)
            newItem[kSecValueData as String] = data as AnyObject?

            let status = SecItemAdd(newItem as CFDictionary, nil)
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
    }

    public func delete(key: String) throws {
        let query = keychainQuery(key: key)
        let status = SecItemDelete(query as CFDictionary)
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }

    private func keychainQuery(key: String) -> [String: AnyObject] {
        var query: [String: AnyObject] = [:]
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrAccount as String] = key as AnyObject?
        return query
    }
}
