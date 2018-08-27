//
//  EQQuote.swift
//  EagleQuote
//
//  Created by Lorence Lim on 27/08/2018.
//  Copyright © 2018 Lorence Lim. All rights reserved.
//

import Foundation


struct EQQuote: Codable {
    let quoteID: Int
    let createdAt: String
    let clients: [EQClient]
    
    enum CodingKeys: String, CodingKey {
        case quoteID = "quoteId"
        case createdAt = "createdAt"
        case clients = "clients"
    }
}

// MARK: Convenience initializers and mutators

extension EQQuote {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EQQuote.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        quoteID: Int? = nil,
        createdAt: String? = nil,
        clients: [EQClient]? = nil
        ) -> EQQuote {
        return EQQuote(
            quoteID: quoteID ?? self.quoteID,
            createdAt: createdAt ?? self.createdAt,
            clients: clients ?? self.clients
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
