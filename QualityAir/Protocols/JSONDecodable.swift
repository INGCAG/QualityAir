//
//  JSONDecodable.swift
//  QualityAir
//
//  Created by Cesar A. Guayara L. on 26/06/2019.
//  Copyright © 2019 INGCAG. All rights reserved.
//

import Foundation

protocol JSONDecodable {
    
    init?(JSON: Any)
    
}

/*
public protocol JSONDecodable {
    
    init(decoder: newJSONDecoder) throws
    
}

public enum JSONDecoderError: Error {
    case invalidData
    case keyNotFound(String)
    case keyPathNotFound(String)
}

public struct newJSONDecoder {
    
    typealias JSON = [String: AnyObject]
    
    // MARK: - Properties
    
    private let JSONData: JSON
    
    // MARK: - Static Methods
    
    public static func decode<T: JSONDecodable>(data: Data) throws -> T {
        let decoder = try newJSONDecoder(data: data)
        return try T(decoder: decoder)
    }
    
    // MARK: - Initialization
    private init(JSONData: JSON) {
        self.JSONData = JSONData
    }
    
    public init(data: Data) throws {
        if let JSONData = try JSONSerialization.jsonObject(with: data, options: []) as? JSON {
            self.JSONData = JSONData
        } else {
            throw JSONDecoderError.invalidData
        }
    }
    
    // MARK: - decode
    func decode<T>(key: String) throws -> T {
        if key.contains(".") {
            return try value(forKeyPath: key)
        }
        
        guard let value: T = try? value(forKey: key) else { throw JSONDecoderError.keyNotFound(key) }
        return value
    }
    
    func decode<T: JSONDecodable>(key: String) throws -> [T] {
        if key.contains(".") {
            return try value(forKeyPath: key)
        }
        
        guard let value: [T] = try? value(forKey: key) else { throw JSONDecoderError.keyNotFound(key) }
        return value
    }
    
    // MARK: - handle values
    private func value<T>(forKey key: String) throws -> T {
        guard let value = JSONData[key] as? T else { throw JSONDecoderError.keyNotFound(key) }
        return value
    }
    
    private func value<T>(forKeyPath keyPath: String) throws -> T {
        var partial = JSONData
        let keys = keyPath.components(separatedBy: ".")
        
        for i in 0..<keys.count {
            if i < keys.count - 1 {
                if let partialJSONData = JSONData[keys[i]] as? JSON {
                    partial = partialJSONData
                } else {
                    throw JSONDecoderError.invalidData
                }
                
            } else {
                return try newJSONDecoder(JSONData: partial).value(forKey: keys[i])
            }
        }
        
        throw JSONDecoderError.keyPathNotFound(keyPath)
    }
    
    private func value<T: JSONDecodable>(forKey key: String) throws -> [T] {
        if let value = JSONData[key] as? [JSON] {
            return try value.map({ (partial) -> T in
                let decoder = newJSONDecoder(JSONData: partial)
                return try T(decoder: decoder)
            })
        }
        
        throw JSONDecoderError.keyNotFound(key)
    }
    
    private func value<T: JSONDecodable>(forKeyPath keyPath: String) throws -> [T] {
        var partial = JSONData
        let keys = keyPath.components(separatedBy: ".")
        
        for i in 0..<keys.count {
            if i < keys.count - 1 {
                if let partialJSONData = JSONData[keys[i]] as? JSON {
                    partial = partialJSONData
                } else {
                    throw JSONDecoderError.invalidData
                }
                
            } else {
                return try newJSONDecoder(JSONData: partial).value(forKey: keys[i])
            }
        }
        
        throw JSONDecoderError.keyPathNotFound(keyPath)
    }
    
}

*/
