//
//  AddSpeakerRequest.swift
//  Speaker
//
//  Created by Тихон on 25.08.2021.
//

import Foundation

struct AddSpeakerRequest: Encodable {
    let api_token: String
    let contract: Int
}

struct AddSpeakerResponse: Decodable {
    let code: Int
}

struct CredentialsForSpeaker: Encodable {
    let ssid: String
    let psk: String
    let code: Int
}
