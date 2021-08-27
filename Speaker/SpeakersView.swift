//
//  SpeakersView.swift
//  Speaker
//
//  Created by Тихон on 23.08.2021.
//

import SwiftUI

struct SpeakersView: View {
    @ObservedObject var speakersViewModel = SpeakersViewModel()
    
    var body: some View {
        ZStack {
            if speakersViewModel.responseData == nil {
                ProgressView()
                    .scaleEffect(2)
            } else {
                speakers
            }
        }
        .alert(isPresented: $speakersViewModel.requestError, content: {
            Alert(title: Text("Ошибка загрузки данных."))
        })
        .onAppear(perform: speakersViewModel.fetchData)
    }
    
    var speakers: some View {
        VStack {
            NavigationView {
                ScrollView {
                    VStack(spacing: 30) {
                        Text("Выберите врача, к которому привязать колонку.")
                            .padding([.top])
                        
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

struct SpeakersView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorNavigationItem(doctor: doctorResponse(name: "Имя", patient_name: "Имя пациента", doctor_name: "Имя доктора", specialty: "Специальность доктора", clinic: doctorResponseClinic(id: 12, name: "Клиника", timezone: "timezone", logo_id: nil, full_logo_id: nil, nonsquare_logo_id: nil, video_enabled: false), mainDoctor: "mainDoctor", startDate: "", endDate: "", contract: 3808, photo_id: 2, archive: false, sent: 0, received: 2, short_name: "Короткое имя", state: "state", number: "", unread: nil, is_online: true, role: "роль"))
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
        .background(Color.gray.opacity(0.6))
        .cornerRadius(10)
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .padding()
    }
    
    var metaView: some View {
        VStack {
            Text(doctor.doctor_name)
                .font(.title)
                .foregroundColor(Color.black)
                .multilineTextAlignment(.leading)
            Text(doctor.role)
                .font(.callout)
                .foregroundColor(Color.black)
                .multilineTextAlignment(.leading)
            Text(doctor.clinic.name)
                .foregroundColor(Color.black)
                .multilineTextAlignment(.leading)
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

