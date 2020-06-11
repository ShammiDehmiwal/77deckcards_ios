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
    var data : LoginObject?
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
        var subscribe : String?
    }
}

struct CardListResponse : Decodable {
    
    var status : Bool
    var message : String
    var data : [Card]?
        
//    struct DataCard : Decodable
//    {
//        var records : [Card]
//    }
   
}


struct HelpShowResponse : Decodable {
    
    var status : Bool
    var message : String
    var data : DataHelp?
        
    struct DataHelp : Decodable
    {
        var description : String
        var created_at : String
        var updated_at : String
    }
   
}


struct JournalListResponse : Decodable {
    
    var status : Bool
    var message : String
    var data : Journals?
        
    struct Journals : Decodable
    {
        var journals : [JournalObject]
        
        struct JournalObject : Decodable {
            var id : String?
            var description : String?
            var user_id : String?
            var status : String?
            var add_date : String?
        }
    }
   
}

struct AddJournalResponse : Decodable {
    
    var status : Bool
    var message : String
  //  var data : Any?
        
//    struct Journals : Decodable
//    {
//        var journals : [JournalObject]
//
//        struct JournalObject : Decodable {
//            var id : String?
//            var description : String?
//            var user_id : String?
//            var status : String?
//            var add_date : String?
//        }
//    }
   
}

struct FriendListResponse : Decodable {
    
    var status : Bool
    var message : String
    var data : [Friend]
        
    struct Friend : Decodable
    {
        var id : String?
        var image : String?
        var name : String?
        var phone_no : String?
    }
   
}
