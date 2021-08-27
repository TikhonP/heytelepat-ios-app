//
//  LoginViewModels.swift
//  Speaker
//
//  Created by Тихон on 19.08.2021.
//

import Foundation


final class LoginViewModel: ObservableObject {
    @Published var error: String = "Неизвестная ошибка!"
    @Published var showError: Bool = false
    
    @Published var showLoader = false
    
    @Published var username: String = ""
    @Published var password: String = ""
    
    func auth(updateViewFunc: @escaping() -> Void) {
        self.showLoader = true
        self.showError = false
        
        let requestModel = getTokenRequest(
            email: self.username,
            password: self.password,
            platform: "speaker app",
            browser: "",
            api_key: nil
        )
        
        var postRequest = LoginApiRequest(endpoint: "/api/client/auth")
        
        postRequest.save(requestModel, completion: { result in
            switch result {
            case .success(let response):
                KeyChainTokenViewModel().insertToken(validToken: response.data.api_token!)
                updateViewFunc()
                self.showLoader = false
            case .failure(let error):
                switch error {
                case .UserIsNotActivated:
                    self.error = "Пользователь еще не активирован!"
                case .IncorrectData:
                    self.error = "Пользователь не найден!"
                case .IncorrectPassword:
                    self.error = "Неверный пароль!"
                default:
                    self.error = "Неизвестная ошибка!"
                }
                self.showError = true
                self.showLoader = false
                
                #if DEBUG
                print("An error occured \(error.localizedDescription) \(error)")
                #endif
            }
        })
    }
}

