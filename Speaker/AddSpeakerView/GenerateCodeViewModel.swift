//
//  GenerateCodeViewModel.swift
//  Speaker
//
//  Created by Тихон on 24.08.2021.
//

import Foundation
import AVFoundation


extension URLSession {
    func syncRequest(with url: URL) -> (Data?, URLResponse?, Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let dispatchGroup = DispatchGroup()
        let task = dataTask(with: url) {
            data = $0
            response = $1
            error = $2
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        task.resume()
        dispatchGroup.wait()
        
        return (data, response, error)
    }
    
    func syncRequest(with request: URLRequest) -> (Data?, URLResponse?, Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let dispatchGroup = DispatchGroup()
        let task = dataTask(with: request) {
            data = $0
            response = $1
            error = $2
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        task.resume()
        dispatchGroup.wait()
        
        return (data, response, error)
    }
}


final class GenerateCodeViewModel: ObservableObject {
    @Published var ssid: String = ""
    @Published var password: String = ""
    @Published var ssids: [String] = currentSSIDs()
    
    @Published var requestError: Bool = false
    @Published var showLoader: Bool = false
    @Published var playing: Bool = false
    
    private var audioPlayer: AVAudioPlayer?
    
    func generateCode(doctor: doctorResponse) {
        self.showLoader = true
        self.requestError = false
        self.playing = false
        
        do {
            print("heree")
            let requestData = try JSONEncoder().encode(AddSpeakerRequest(api_token: medsengerApiKey!, contract: doctor.contract))
            
            print(String(decoding: requestData, as: UTF8.self))
            
            let url = URL(string: "http://\(speakerServerDomain)/mobile/api/v1/speaker/")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = requestData
            
            let (data, response, error) = URLSession.shared.syncRequest(with: request)
            
            guard let responseData = data, error == nil, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                guard let responseData = data else {
                    print("Error with request!")
                    self.requestError = true
                    self.showLoader = false
                    return
                }
                
                print("Error with request! \(String(decoding: responseData, as: UTF8.self))")
                self.requestError = true
                self.showLoader = false
                return
            }
            
            do {
                let responseDataJson = try JSONDecoder().decode(AddSpeakerResponse.self, from: responseData)
                
                let credentialsForSpeaker = CredentialsForSpeaker(ssid: self.ssid, psk: self.password, code: responseDataJson.code)
                do {
                    let jsonData = try JSONEncoder().encode(credentialsForSpeaker)
                    let jsonString = String(data: jsonData, encoding: .utf8)!
                    
                    let wavDataUrl = "https://ggwave-to-file.ggerganov.com/?m=\(jsonString)"
                    print(wavDataUrl)
                    
                    checkBookFileExists(withLink: wavDataUrl){ [weak self] downloadedURL in
                        guard let self = self else { return }
                        self.playing = true
                        self.play(url: downloadedURL)
                        self.showLoader = false
                    }
                } catch {
                    print("Encodicng speaker credentials error \(error)")
                    self.requestError = true
                }
            } catch {
                self.requestError = true
                self.showLoader = false
                print("Decoding error \(error)")
                return
            }
        } catch {
            fatalError("Error encoding request!")
        }
    }
    
    func checkBookFileExists(withLink link: String, completion: @escaping ((_ filePath: URL)->Void)){
        let urlString = link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let url  = URL(string: urlString ?? "") {
            let fileManager = FileManager.default
            if let documentDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create: false) {
                
                let filePath = documentDirectory.appendingPathComponent("\(UUID().uuidString).wav", isDirectory: false)

                downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
            } else {
                print("Document directory error")
            }
        } else {
            print("URL invalid")
        }
    }
    
    func downloadFile(withUrl url: URL, andFilePath filePath: URL, completion: @escaping ((_ filePath: URL)->Void)){
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: url)
                try data.write(to: filePath, options: .atomic)
                print("saved at \(filePath.absoluteString)")
                DispatchQueue.main.async {
                    completion(filePath)
                }
            } catch {
                print("an error happened while downloading or saving the file")
            }
        }
    }
    
    func play(url: URL) {
        print("playing \(url)")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            //            audioPlayer?.delegate = self
            audioPlayer?.play()
            //            let percentage = (audioPlayer?.currentTime ?? 0)/(audioPlayer?.duration ?? 0)
            
            
            
        } catch let error {
            audioPlayer = nil
            print("Error playing \(error)")
        }
        
    }
}
