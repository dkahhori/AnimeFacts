//
//  Anime.swift
//  AnimeFacts
//
//  Created by Dilshodi Kahori on 04/11/22.
//

import Foundation

enum Link: String {
    case animeURL = "https://anime-facts-rest-api.herokuapp.com/api/v1"
}

struct Anime: Decodable {
    let status: Bool
    let animeDetails: [AnimeDetail]
    
    struct AnimeDetail: Decodable {
        let id: Int
        let name: String
        let image: String
        
        enum CodingKeys: String, CodingKey {
            case id = "anime_id"
            case name = "anime_name"
            case image = "anime_img"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case status = "success"
        case animeDetails = "data"
    }
}
