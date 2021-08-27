//
//  SpeakersViewModel.swift
//  Speaker
//
//  Created by Тихон on 23.08.2021.
//

import Foundation


final class SpeakersViewModel: ObservableObject {
    @Published var responseData: Array<doctorResponse>?
    @Published var requestError: Bool = false
    
    func fetchData() {
        if responseData == nil {
            requestError = false
            
            var resourceURLComponents = URLComponents()
            resourceURLComponents.scheme = "https"
            resourceURLComponents.host = medsengerApiDomain
            resourceURLComponents.path = "/api/client/doctors"
            resourceURLComponents.queryItems = [
                URLQueryItem(name: "api_token", value: medsengerApiKey),
            ]
            
            guard let resourceURL = resourceURLComponents.url else { fatalError("Cannot create url for doctor request.") }
            
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                DispatchQueue.main.async {
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                        self.requestError = true
                        #if DEBUG
                        print("Unknown error while doctors request")
                        #endif
                        return
                    }
                    
                    do {
                        let response = try JSONDecoder().decode(doctorsResponse.self, from: jsonData)
                        self.responseData = response.data
                    } catch {
                        self.requestError = true
                        #if DEBUG
                        print("Decoding error: \(error).")
                        print("Data \(String(decoding: jsonData, as: UTF8.self))")
                        #endif
                    }
                }
            }.resume()
        }
    }
}
