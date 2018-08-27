//
//  EQPremium.swift
//  EagleQuote
//
//  Created by Lorence Lim on 27/08/2018.
//  Copyright © 2018 Lorence Lim. All rights reserved.
//

import Foundation


struct EQPremium: Codable {
    let minTotalPremium: Double
    let maxTotalPremium: Double
    
    enum CodingKeys: String, CodingKey {
        case minTotalPremium = "minTotalPremium"
        case maxTotalPremium = "maxTotalPremium"
    }
}

// MARK: Convenience initializers and mutators

extension EQPremium {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EQPremium.self, from: data)
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
        minTotalPremium: Double? = nil,
        maxTotalPremium: Double? = nil
    ) -> EQPremium {
        return EQPremium(
            minTotalPremium: minTotalPremium ?? self.minTotalPremium,
            maxTotalPremium: maxTotalPremium ?? self.maxTotalPremium
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
