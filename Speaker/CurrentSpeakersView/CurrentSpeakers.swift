//
//  CurrentSpeakers.swift
//  Speaker
//
//  Created by Тихон on 27.08.2021.
//

import SwiftUI

struct CurrentSpeakers: View {
    @EnvironmentObject var currentSpeakersViewModel: CurrentSpeakersViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    var body: some View {
        if networkMonitor.isConnected {
            ZStack {
                if currentSpeakersViewModel.speakersData == nil {
                    CustomProgressView()
                } else {
                    if currentSpeakersViewModel.speakersData!.isEmpty {
                        Text("Вы не добавили ни одного устройства, перейдите во вкладку \"Добавить\" для инициализации нового устройства.")
                            .foregroundColor(.gray)
                    } else {
                        main
                    }
                }
            }
            .alert(isPresented: $currentSpeakersViewModel.requestError, content: {
                Alert(title: Text("Ошибка загрузки данных."))
            })
            .onAppear(perform: currentSpeakersViewModel.fetchData)
        } else {
            OfflineView()
        }
    }
    
    var main: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    ForEach(currentSpeakersViewModel.speakersData!) { speaker in
                        NavigationLink(
                            destination: SpeakerSettings(speaker: speaker),
                            label: {
                                SpeakerItem(speaker: speaker)
                            })
                    }
                }
                .navigationBarTitle("Ваши колонки")
            }
        }
    }
}

struct SpeakerItem: View {
    let speaker: SpeakerData
    
    var body: some View {
        HStack {
            Image("speaker")
                .resizable()
                .frame(width: 80, height: 80)
                .padding()
            Text("Врач: \(speaker.doctorName)")
                .padding()
        }
    }
}

struct SpeakerSettings: View {
    let speaker: SpeakerData
    
    var body: some View {
        Form {
            Section(header: Text("Подключение")) {
                HStack {
                    Text("Поликлиника")
                    Spacer()
                    Text(speaker.clinic)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Врач")
                    Spacer()
                    Text(speaker.doctorName)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("ID контракта")
                    Spacer()
                    Text("\(speaker.contract)")
                        .foregroundColor(.gray)
                }
            }
            
            Section(header: Text("Устройство")) {
                HStack {
                    Text("Версия прошивки")
                    Spacer()
                    Text(speaker.speaker.version)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct CurrentSpeakers_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CurrentSpeakers()
            //            SpeakerItem(speaker: SpeakersListResponse(id: 12, code: "12345", token: "dlkadql", version: "1.2.2"))
            //                .previewLayout(PreviewLayout.sizeThatFits)
            //                .padding()
        }
    }
}
