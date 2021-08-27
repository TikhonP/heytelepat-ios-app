//
//  DoctorsRequestModels.swift
//  Speaker
//
//  Created by Тихон on 23.08.2021.
//

import Foundation


struct doctorsResponse: Decodable {
    let data: Array<doctorResponse>
    let state: String
}


struct doctorResponse: Decodable, Identifiable {
    var id: UUID? = UUID()
    
    let name: String
    let patient_name: String
    let doctor_name: String
    let specialty: String
    let clinic: doctorResponseClinic
    let mainDoctor: String
    let startDate: String
    let endDate: String
    let contract: Int
    let photo_id: Int
    let archive: Bool
    let sent: Int
    let received: Int
    let short_name: String
    let state: String
    let number: String
    let unread: Int?
    let is_online: Bool
    // ...
    let role: String
}

struct doctorResponseClinic: Decodable {
    let id: Int
    let name: String
    let timezone: String
    let logo_id: Int?
    let full_logo_id: Int?
    let nonsquare_logo_id: Int?
    let video_enabled: Bool
}
