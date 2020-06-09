//
//  Addon.swift
//  JudlauApp
//
//  Created by Reena on 30/01/20.
//  Copyright © 2020 sam. All rights reserved.
//

import Foundation

struct UserDetail:Codable {
    var id : Int
    var PhoneNumber:Int64?
    var app_status:Int?
    var created_at:String?
    var updated_at:String?
    var status:String?
    var access_token : String?
    var token_expires_at : Int64
    var subscribeStatus : Int?
    
    init(iID : Int,iPhoneNumber : Int64,iAppStatus : Int,strCreatedAt:String,strUpdatedAt:String,status : String,strAccessToken : String, strTokenExpire : Int64,subscribeStatus : Int) {
        self.id = iID
        self.PhoneNumber = iPhoneNumber
        self.app_status = iAppStatus
        self.created_at = strCreatedAt
        self.updated_at = strUpdatedAt
        self.status = status
        self.access_token = strAccessToken
        self.token_expires_at = strTokenExpire
        self.subscribeStatus = subscribeStatus
    }
    
}



func saveUserDetailInUserDefault(strKey : String, obj : UserDetail)
{
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(obj) {
        let defaults = UserDefaults.standard
        defaults.set(encoded, forKey: strKey)
    }
    
}

func fetchUserDetailInUserDefault(strKey : String) -> UserDetail?
{
    if let savedPerson = UserDefaults.standard.object(forKey: strKey) as? Data {
        let decoder = JSONDecoder()
        if let loadedPerson = try? decoder.decode(UserDetail.self, from: savedPerson) {
            print("Save Emp : \(loadedPerson)")
            
            return loadedPerson
        }
    }
    
    return nil
}

func isExistUserDetailInUserDefault(strKey : String) -> Bool
{
    if let savedPerson = UserDefaults.standard.object(forKey: strKey) as? Data {
        let decoder = JSONDecoder()
        if (try? decoder.decode(UserDetail.self, from: savedPerson)) != nil {
            return true
        }
    }
    
    return false
}

func removeUserDetailInUserDefault(strKey : String) -> Bool
{
    if (UserDefaults.standard.object(forKey: strKey) as? Data) != nil {
        UserDefaults.standard.removeObject(forKey: strKey)
       return UserDefaults.standard.synchronize()
    }
    
    return true
}
