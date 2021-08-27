//
//  LoginView.swift
//  Speaker
//
//  Created by Тихон on 19.08.2021.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var networkMonitor: NetworkMonitor
    @ObservedObject var rootViewModel: RootViewModel
    
    @ObservedObject var loginViewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            LogoIconLoginView()
            TitleLoginView()
            Spacer()
            usernameField
            PasswordField(password: $loginViewModel.password)
            Spacer()
            
            if !networkMonitor.isConnected {
                CardView(text: "Интернет не доступен")
                Spacer()
            }
            
            if loginViewModel.showError {
                CardView(text: loginViewModel.error)
                Spacer()
            }
            
            if loginViewModel.showLoader {
                ProgressView()
            } else {
                Button(action: commitButtonAction, label: { ButtonLoginView() })
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
}


#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(networkMonitor: NetworkMonitor(), rootViewModel: RootViewModel())
    }
}
#endif


struct PasswordField: View {
    @Binding var password: String
    
    @State var hidePassword: Bool = true
    
    var body: some View {
        ZStack {
            if hidePassword {
                SecureField("Пароль", text: $password)
                    .padding()
                    .background(Color("lightGray"))
                    .cornerRadius(5.0)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textContentType(.password)
            } else {
                TextField("Пароль", text: $password)
                    .padding()
                    .background(Color("lightGray"))
                    .cornerRadius(5.0)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textContentType(.password)
            }
            
            HStack {
                Spacer()
                Button(action: { hidePassword.toggle() }, label: {
                    Image(systemName: hidePassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                })
                .padding()
            }
        }
    }
}

struct LogoIconLoginView: View {
    var body: some View {
        Image("loginIcon")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipShape(Circle())
            //            .shadow(radius: 10)
            .padding()
    }
}

struct TitleLoginView: View {
    var body: some View {
        Text("Medsenger Speaker")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .padding()
    }
}

struct ButtonLoginView: View {
    var body: some View {
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

