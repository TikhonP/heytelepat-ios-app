//
//  LoginView.swift
//  Speaker
//
//  Created by Тихон on 19.08.2021.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var rootViewModel: RootViewModel
    
    @ObservedObject var loginViewModel = LoginViewModel()
    
    var body: some View {
        if networkMonitor.isConnected {
            mainBody
        } else {
            OfflineView()
        }
    }
    
    var mainBody: some View {
        VStack {
            logoIconLoginView
            titleLoginView
            Spacer()
            usernameField
            PasswordFieldView(password: $loginViewModel.password)
            Spacer()
            
            if loginViewModel.showError {
                CardView(text: loginViewModel.error)
                Spacer()
            }
            
            if loginViewModel.showLoader {
                ProgressView()
            } else {
                Button(action: commitButtonAction, label: { buttonLoginView })
                    .disabled(commitButtonIsDisabled)
                    .opacity(commitButtonIsDisabled ? 0.5 : 1)
                    .animation(.default)
            }
            
            Spacer()
        }
        .padding()
    }
    
    var commitButtonIsDisabled: Bool {
        return !networkMonitor.isConnected || loginViewModel.username.isEmpty || loginViewModel.password.isEmpty
    }
    
    func commitButtonAction() {
        loginViewModel.auth(updateViewFunc: rootViewModel.updateProperty)
    }
    
    var usernameField: some View {
        TextField("Email", text: $loginViewModel.username)
            .padding()
            .textContentType(.username)
            .background(Color("lightGray"))
            .cornerRadius(5.0)
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
    
    var logoIconLoginView: some View {
        Image("loginIcon")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            //            .clipShape(Circle())
            //            .shadow(radius: 10)
            .padding()
    }
    
    var titleLoginView: some View {
        Text("Medsenger Speaker")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    var buttonLoginView: some View {
        Text("Войти")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color("BlackAndWhite"))
            .cornerRadius(35)
    }
}

struct CardView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.red, lineWidth: 1)
            )
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
                .environmentObject(NetworkMonitor())
                .environmentObject(RootViewModel())
            CardView(text: "Card text")
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
        }
    }
}
