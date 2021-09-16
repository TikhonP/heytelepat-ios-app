//
//  SpeakersViewModel.swift
//  Speaker
//
//  Created by Тихон on 23.08.2021.
//

import Foundation


func listOfDoctorsRequest() -> Array<doctorResponse>? {
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
    
    let (data, response, _) = URLSession.shared.syncRequest(with: urlRequest)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
        print("Unknown error while doctors request")
        return nil
    }
    
    do {
        let response = try JSONDecoder().decode(doctorsResponse.self, from: jsonData)
        return response.data
    } catch let DecodingError.dataCorrupted(context) {
        print(context)
    } catch let DecodingError.keyNotFound(key, context) {
        print("Key '\(key)' not found:", context.debugDescription)
        print("codingPath:", context.codingPath)
    } catch let DecodingError.valueNotFound(value, context) {
        print("Value '\(value)' not found:", context.debugDescription)
        print("codingPath:", context.codingPath)
    } catch let DecodingError.typeMismatch(type, context)  {
        print("Type '\(type)' mismatch:", context.debugDescription)
        print("codingPath:", context.codingPath)
    } catch {
        print("error: ", error)
    }
    
    return nil
}

final class SpeakersViewModel: ObservableObject {
    @Published var responseData: Array<doctorResponse>?
    @Published var requestError: Bool = false
    
    func fetchData() {
        if responseData == nil {
            requestError = false
            
            DispatchQueue.main.async {
                let response = listOfDoctorsRequest()
                if response == nil {
                    self.requestError = true
                } else {
                    self.responseData = response
                }
            }
        }
    }
}
