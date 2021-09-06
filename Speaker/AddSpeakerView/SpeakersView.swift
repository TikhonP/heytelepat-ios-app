//
//  SpeakersView.swift
//  Speaker
//
//  Created by Тихон on 23.08.2021.
//

import SwiftUI

struct SpeakersView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var speakersViewModel: SpeakersViewModel
    
    var body: some View {
        if networkMonitor.isConnected {
            ZStack {
                if speakersViewModel.responseData == nil {
                    CustomProgressView()
                } else {
                    speakers
                }
            }
            .alert(isPresented: $speakersViewModel.requestError, content: {
                Alert(title: Text("Ошибка загрузки данных."))
            })
            .onAppear(perform: speakersViewModel.fetchData)
        } else {
            OfflineView()
        }
    }
    
    var speakers: some View {
        VStack {
            NavigationView {
                ScrollView {
                    VStack {
                        HStack {
                            Text("Выберите врача, к которому привязать колонку.")
                            Spacer()
                        }
                        .padding()
                        
                        ForEach(speakersViewModel.responseData!) { doctor in
                            NavigationLink(
                                destination: GenerateCodeView(doctor: doctor),
                                label: { DoctorNavigationItem(doctor: doctor) })
                        }
                    }
                    .navigationBarTitle("Ваши врачи")
                }
            }
        }
    }
}

struct DoctorNavigationItem: View {
    let doctor: doctorResponse
    
    var body: some View {
        HStack {
            DoctorImageView(imageUrl: getDoctorImageUrl(), doctorIsOnline: doctor.is_online)
            Spacer()
            metaView
            Spacer()
        }
        .background(Color.accentColor)
        .cornerRadius(10)
        .shadow(radius: 10)
        .padding()
    }
    
    var metaView: some View {
        VStack {
            HStack {
                Text(doctor.doctor_name)
                    .font(.title)
                    .foregroundColor(Color.black)
                Spacer()
            }
            HStack {
                Text(doctor.role)
                    .font(.callout)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            HStack {
                Text(doctor.clinic.name)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
        }
        .frame(width: 220, alignment: .leading)
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
}

struct DoctorImageView: View {
    let imageUrl: URL
    let doctorIsOnline: Bool
    
    var body: some View {
        ZStack {
            AsyncImage(
                url: imageUrl,
                placeholder: { ProgressView() },
                image: { Image(uiImage: $0).resizable() }
            )
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
            .padding()
            VStack {
                HStack {
                    Spacer()
                    Circle()
                        .foregroundColor(doctorIsOnline ? .green : .red)
                        .frame(width: 20, height: 20)
                        .padding()
                }
                Spacer()
            }
        }
        .frame(height: 110)
    }
}


struct SpeakersView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SpeakersView()
                .environmentObject(NetworkMonitor())
            DoctorNavigationItem(doctor: doctorResponse.preview)
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
        }
    }
}
