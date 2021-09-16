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
    let id: UUID = UUID()
    
    let name: String
    let patient_name: String
    let doctor_name: String
    let specialty: String
    let clinic: doctorResponseClinic
    let mainDoctor: String
    let startDate: String
    let endDate: String
    let contract: Int
    let photo_id: Int?
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
    
    private enum CodingKeys : String, CodingKey {
        case name, patient_name, doctor_name, specialty, clinic, mainDoctor, startDate, endDate, contract, photo_id, archive, sent, received, short_name, state, number, unread, is_online, role
    }
}

extension doctorResponse {
  /// Default Doctor
  static let preview = doctorResponse(name: "Имя", patient_name: "Имя пациента", doctor_name: "Имя доктора", specialty: "Специальность доктора", clinic: doctorResponseClinic(id: 12, name: "Клиника", timezone: "timezone", logo_id: nil, full_logo_id: nil, nonsquare_logo_id: nil, video_enabled: false), mainDoctor: "mainDoctor", startDate: "", endDate: "", contract: 3808, photo_id: 2, archive: false, sent: 0, received: 2, short_name: "Короткое имя", state: "state", number: "", unread: nil, is_online: true, role: "роль")
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
