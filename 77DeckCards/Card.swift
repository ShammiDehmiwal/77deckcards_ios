//
//  Card.swift
//  77DeckCards
//
//  Created by Himanshu Singla on 27/05/18.
//  Copyright © 2018 Creations. All rights reserved.
//

import Foundation
struct ResponseData: Decodable {
    var card: [Card]
}
struct Card : Decodable {
    var id : String?
    var card_title : String?
    var card_decription : String?
    var full_description : String?
    var poem : String?
    var artist_description : String?
    var created_at : String?
    var updated_at : String?
    var name: String?
    var desc: String?
    var image: String?
    var imageLink : String?
}
