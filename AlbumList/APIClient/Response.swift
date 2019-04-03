//
//  Response.swift
//  AlbumList
//
//  Created by melisa öztürk on 3.04.2019.
//  Copyright © 2019 melisa öztürk. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias AlbumResponse = [AlbumResponseElement]

struct AlbumResponseElement: Decodable {
    let albumID: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailURL: String
    
    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id
        case title
        case url
        case thumbnailURL = "thumbnailUrl"
    }
}
