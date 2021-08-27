//
//  PasswordFieldView.swift
//  Speaker
//
//  Created by Тихон on 27.08.2021.
//

import SwiftUI

struct PasswordFieldView: View {
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

struct PasswordFieldView_Previews: PreviewProvider {
    @State var password = ""
    
    static var previews: some View {
        PasswordFieldView(password: .constant(""))
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
    }
}
