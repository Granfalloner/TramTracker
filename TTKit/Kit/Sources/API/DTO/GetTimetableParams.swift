//
//  GetTimetableParams.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 07/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation

public class GetTimetableParams: BaseParams {
    let busstopId: String
    let busstopNr: String
    let line: Int

    init(stopId: String, line: Int) {
        self.busstopId = String(stopId.prefix(4))
        self.busstopNr = String(stopId.suffix(2))
        self.line = line
        super.init()
    }

    // MARK: - Encodable

    enum CodingKeys: String, CodingKey {
        case busstopId
        case busstopNr
        case line
    }

    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(busstopId, forKey: .busstopId)
        try container.encode(busstopNr, forKey: .busstopNr)
        try container.encode(line, forKey: .line)
    }
}

// MARK: - Equatable

extension GetTimetableParams: Equatable {
    public static func == (lhs: GetTimetableParams, rhs: GetTimetableParams) -> Bool {
        return lhs.busstopId == rhs.busstopId && lhs.busstopNr == rhs.busstopNr && lhs.line == rhs.line
    }
}

// MARK: - Hashable

extension GetTimetableParams: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(busstopId)
        hasher.combine(busstopNr)
        hasher.combine(line)
    }
}
