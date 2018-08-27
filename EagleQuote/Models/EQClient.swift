//
//  EQClient.swift
//  EagleQuote
//
//  Created by Lorence Lim on 27/08/2018.
//  Copyright © 2018 Lorence Lim. All rights reserved.
//

import Foundation


struct EQClient: Codable {
    let id: Int
    let name: String
    let gender: String
    let age: Int
    let occupationID: Int
    let employedStatus: String
    let isSmoker: Bool
    let isChild: Bool
    let isPrimary: Bool
    let premiums: EQPremium
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case gender = "gender"
        case age = "age"
        case occupationID = "occupationId"
        case employedStatus = "employedStatus"
        case isSmoker = "isSmoker"
        case isChild = "isChild"
        case isPrimary = "isPrimary"
        case premiums = "premiums"
    }
    
    func smokerString() -> String {
        return isSmoker ? "Smoker" : "Non-smoker"
    }
}

// MARK: Convenience initializers and mutators

extension EQClient {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EQClient.self, from: data)
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
        id: Int? = nil,
        name: String? = nil,
        gender: String? = nil,
        age: Int? = nil,
        occupationID: Int? = nil,
        employedStatus: String? = nil,
        isSmoker: Bool? = nil,
        isChild: Bool? = nil,
        isPrimary: Bool? = nil,
        premiums: EQPremium? = nil
    ) -> EQClient {
        return EQClient(
            id: id ?? self.id,
            name: name ?? self.name,
            gender: gender ?? self.gender,
            age: age ?? self.age,
            occupationID: occupationID ?? self.occupationID,
            employedStatus: employedStatus ?? self.employedStatus,
            isSmoker: isSmoker ?? self.isSmoker,
            isChild: isChild ?? self.isChild,
            isPrimary: isPrimary ?? self.isPrimary,
            premiums: premiums ?? self.premiums
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
