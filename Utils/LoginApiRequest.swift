//
//  ApiRequest.swift
//  Speaker
//
//  Created by Тихон on 19.08.2021.
//

import Foundation

enum APIError: Error {
    case UserIsNotActivated
    case IncorrectData
    case IncorrectPassword
    case badRequest
    case resposeProblem
    case decodingProblem
    case encodingProblem
}

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

struct LoginApiRequest {
    var resourceURLComponents: URLComponents
    
    init(endpoint: String) {
        self.resourceURLComponents = URLComponents()
        self.resourceURLComponents.scheme = "https"
        self.resourceURLComponents.host = medsengerApiDomain
        self.resourceURLComponents.path = endpoint
    }
    
    mutating func save (_ requestModel: getTokenRequest, completion: @escaping(Result<getTokenResponse, APIError>) -> Void) {
        self.resourceURLComponents.setQueryItems(with: requestModel.queryParams)
        
        guard let resourceURL = self.resourceURLComponents.url else { fatalError("Cannot create url.") }
        
        var urlRequest = URLRequest(url: resourceURL)
        urlRequest.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                    guard let jsonData = data else {
                        print("Empty Data on request!")
                        completion(.failure(.resposeProblem))
                        return
                    }
                    
                    do {
                        let messagesData = try JSONDecoder().decode(authErrorReponse.self, from: jsonData)
                        if messagesData.error[0] == "User is not activated" {
                            completion(.failure(.UserIsNotActivated))
                        } else if messagesData.error[0] == "Incorrect data" {
                            completion(.failure(.IncorrectData))
                        } else if messagesData.error[0] == "Incorrect password" {
                            completion(.failure(.IncorrectPassword))
                        } else {
                            completion(.failure(.badRequest))
                        }
                    } catch {
                        #if DEBUG
                        print("Unexpected error: \(error).")
                        print("Data \(String(decoding: data!, as: UTF8.self))")
                        #endif
                        completion(.failure(.resposeProblem))
                    }
                    return
                }
                
                do {
                    let messagesData = try JSONDecoder().decode(getTokenResponse.self, from: jsonData)
                    completion(.success(messagesData))
                } catch {
                    print("Unexpected error: \(error).")
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
}
