//
//  ProfileViewModels.swift
//  Speaker
//
//  Created by Тихон on 22.08.2021.
//

import Foundation


final class ProfileViewModel: ObservableObject {
    @Published var profileData: getTokenResponse?
    @Published var fetchDataError: Bool = false
    
    func fetchProfileData(rootViewModel: RootViewModel) {
        if profileData == nil {
            let requestModel = getTokenRequest(
                email: "self.username",
                password: "self.password",
                platform: "speaker app",
                browser: "",
                api_key: medsengerApiKey
            )
            
            var postRequest = LoginApiRequest(endpoint: "/api/client/check")
            
            postRequest.save(requestModel, completion: { result in
                switch result {
                case .success(let response):
                    self.profileData = response
                case .failure(let error):
                    switch error {
                    case .IncorrectPassword:
                        KeyChainTokenViewModel().deleteTokens()
                        rootViewModel.updateProperty()
                    default:
                        print("An error occured \(error.localizedDescription) \(error)")
                        self.fetchDataError = true
                    }
                }
            })
        }
    }
}
