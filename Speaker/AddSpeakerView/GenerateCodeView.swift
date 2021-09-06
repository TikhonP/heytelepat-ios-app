//
//  GenerateCodeView.swift
//  Speaker
//
//  Created by Тихон on 23.08.2021.
//

import SwiftUI

struct GenerateCodeView: View, CustomPicker {
    let doctor: doctorResponse
    
    @ObservedObject var generateCodeViewModel = GenerateCodeViewModel()
    
    @State private var presentPicker = false
    @State private var pickerTag: Int = 1
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    generateCodeInformation
                        .padding()
                    Divider()
                    wifiCredentialsForm
                    Spacer()
                }
                if presentPicker {
                    CustomPickerView(items: generateCodeViewModel.ssids,
                                     pickerField: $generateCodeViewModel.ssid,
                                     presentPicker: $presentPicker,
                                     saveUpdates: saveUpdates)
                        .zIndex(1)
                }
            }
        }
        .navigationBarTitle(doctor.short_name, displayMode: .inline)
        .alert(isPresented: $generateCodeViewModel.requestError, content: { Alert(title: Text("Ошибка запроса на сервер.")) })
    }
    
    var wifiCredentialsForm: some View {
        VStack {
            wifiSsidField
                .padding([.leading, .top, .trailing])
            PasswordFieldView(password: $generateCodeViewModel.password)
                .padding()
            if generateCodeViewModel.showLoader {
                if generateCodeViewModel.playing {
                    HStack{
                        Text("Воспроизводится...")
                            .padding([.trailing])
                        ProgressView()
                    }
                } else {
                    ProgressView()
                }
            } else {
                Button(action: generateButtonAction, label: {
                    Text("Сгенерировать код.")
                })
                .disabled(generateButtonIsDisabled)
                .foregroundColor(generateButtonIsDisabled ? .gray : .blue)
            }
        }
    }
    
    var generateCodeInformation: some View {
        HStack {
            doctorPart
            VStack {
                HStack {
                    Text(doctor.clinic.name)
                        .font(.headline)
                    Spacer()
                }
                HStack {
                    Text(doctor.role)
                    Spacer()
                }
            }
            .frame(width: 220, alignment: .leading)
        }
    }
    
    var doctorPart: some View {
        DoctorImageView(imageUrl: getDoctorImageUrl(), doctorIsOnline: doctor.is_online)
    }
    
    var wifiSsidField: some View {
        CustomPickerTextView(presentPicker: $presentPicker, fieldString: $generateCodeViewModel.ssid, placeholder: "Имя сети (SSID)", tag: $pickerTag, selectedTag: 1)
            .padding()
            .background(Color("lightGray"))
            .cornerRadius(5.0)
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
    
    func getDoctorImageUrl() -> URL {
        var resourceURLComponents = URLComponents()
        resourceURLComponents.scheme = "https"
        resourceURLComponents.host = medsengerApiDomain
        resourceURLComponents.path = "/api/client/doctors/\(doctor.contract)/photo"
        resourceURLComponents.queryItems = [
            URLQueryItem(name: "api_token", value: medsengerApiKey),
        ]
        return resourceURLComponents.url!
    }
    
    func generateButtonAction() {
        generateCodeViewModel.generateCode(contract: doctor.contract)
    }
    
    func saveUpdates(_ newItem: String) {
        generateCodeViewModel.ssids.append(generateCodeViewModel.ssid)
    }
    
    var generateButtonIsDisabled: Bool {
        return generateCodeViewModel.ssid.isEmpty || generateCodeViewModel.ssid.isEmpty
    }
}

struct GenerateCodeView_Previews: PreviewProvider {
    static var previews: some View {
        GenerateCodeView(doctor: doctorResponse.preview)
    }
}
