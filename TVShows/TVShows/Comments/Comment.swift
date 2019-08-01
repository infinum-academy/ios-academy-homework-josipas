//
//  Comment.swift
//  TVShows
//
//  Created by Infinum on 01/08/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import Foundation

struct Comment: Codable {
    let text: String
    let episodeId: String
    let userEmail: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case text
        case episodeId
        case userEmail
        case id = "_id"
    }
}
