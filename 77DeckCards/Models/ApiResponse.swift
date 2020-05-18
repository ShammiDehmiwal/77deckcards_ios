//
//  ApiResponse.swift
//  77DeckCards
//
//  Created by Reena on 13/05/20.
//  Copyright © 2020 Creations. All rights reserved.
//

import Foundation

struct LoginResponse : Codable {
    
    var status : Bool
    var data : LoginObject
    var message : String
    
    struct LoginObject : Codable {
        var id : Int
        var phone_no : Int64?
        var app_status : Int?
        var created_at : String?
        var updated_at : String?
        var status : String?
        var access_token : String?
        var token_expires_at : Int64?
    }
}

struct CardListResponse : Decodable {
    
    var status : Bool
    var message : String
    var data : DataCard?
        
    struct DataCard : Decodable
    {
        var records : [Card]
    }
   
}
