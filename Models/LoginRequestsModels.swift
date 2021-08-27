//
//  LoginRequestsModels.swift
//  Speaker
//
//  Created by Тихон on 19.08.2021.
//

import Foundation

struct getTokenRequest {
    let email: String
    let password: String
    let platform: String
    let browser: String
    let api_key: String?
    
    var get_params: String {
        return "email=\(self.email)&password=\(self.password)&platform=\(self.platform)&browser=\(self.browser)"
    }
    
    var queryParams: [String:String] {
        if let api_key = self.api_key {
            return [
                "api_token": api_key
            ]
        } else {
            return [
                "email": self.email,
                "password": self.password,
                "platform": self.platform,
                "browser": self.browser
            ]
        }
    }
}

struct ruleClassifierElement: Decodable {
    let id: Int
    let name: String
}

struct getTokenResponseData: Decodable {
    let api_token: String?
    let isDoctor: Bool
    let isPatient: Bool
    let name: String
//    let clinics: Array<getTokenResponseDataClinic>
    let email: String?
    let birthday: String
    let phone: String?
    let short_name: String
    let hasPhoto: Bool
    let email_notifications: Bool
}

struct getTokenResponse: Decodable {
    let data: getTokenResponseData
    let state: String
}

struct authErrorReponse: Decodable {
    let error: Array<String>
    let state: String
}

