//
//  Encodable+toJSON.swift
//  NetworkRepository
//
//  Created by 한상진 on 2021/09/22.
//

import Foundation

extension Encodable {
    func toJSON(_ encoder: JSONEncoder = JSONEncoder()) -> [String: Any]? {
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        guard let data = try? encoder.encode(self),
              let object = try? JSONSerialization.jsonObject(with: data),      
              let json = object as? [String: Any] 
        else { return nil }
        
        return json
    }
}
