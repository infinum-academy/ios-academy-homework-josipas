//
//  TvShowItem.swift
//  TVShows
//
//  Created by Infinum on 01/08/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import Foundation

struct TvShowItem : Codable{
    let id: String
    let title: String
    let imageUrl: String
    let likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case imageUrl
        case likesCount
    }
}
