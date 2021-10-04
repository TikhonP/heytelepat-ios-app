//
//  CurrentSpeakersViewModel.swift
//  Speaker
//
//  Created by Тихон on 04.09.2021.
//

import Foundation


struct SpeakerData: Identifiable {
    var id: UUID? = UUID()
    
    let speaker: SpeakersListResponse
    let contract: Int
    let clinic: String
    let doctorName: String
}


final class CurrentSpeakersViewModel: ObservableObject {
    @Published var speakersData: Array<SpeakerData>?
    @Published var requestError: Bool = false
    
    func fetchData() {
        if self.speakersData != nil && !(self.speakersData?.isEmpty ?? true) { return }
        print("Fetching...")
        self.requestError = false
        
        DispatchQueue.main.async {
            print("Requests doctors")
            let doctors = listOfDoctorsRequest()
            print("got doctors")
            if doctors == nil {
                print("Doctors nil")
                self.requestError = true
                return
            }
            
            for doctor in doctors! {
                print("Doctor \(doctor.name)")
                self.makeRequestForSpeakersList(doctor: doctor)
            }
        }
    }
    
    func makeRequestForSpeakersList(doctor: doctorResponse) {
        do {
            let requestData = try JSONEncoder().encode(AddSpeakerRequest(api_token: medsengerApiKey!, contract: doctor.contract))
            
            let url = URL(string: "https://\(speakerServerDomain)/mobile/api/v1/speaker/")!
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = requestData
            
            let (data, response, _) = URLSession.shared.syncRequest(with: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                self.requestError = true
                #if DEBUG
                print("Unknown error while doctors request \(String(decoding: data!, as: UTF8.self))")
                #endif
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Array<SpeakersListResponse>.self, from: jsonData)
                self.speakersData = []
                
                for r in response {
                    let speakerData = SpeakerData(speaker: r, contract: doctor.contract, clinic: doctor.clinic.name, doctorName: doctor.doctor_name)
                    self.speakersData?.append(speakerData)
                }
            } catch {
                self.requestError = true
                
                #if DEBUG
                print("Decoding error: \(error.localizedDescription).")
                print("Data \(String(decoding: jsonData, as: UTF8.self))")
                #endif
            }
            
        } catch {
            print("Error \(error.localizedDescription)")
            self.requestError = true
        }
        
    }
}
