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
                if (currentSpeakersViewModel.speakersData == nil &&  !currentSpeakersViewModel.doctorsIsEmpty) { 
                    CustomProgressView()
                } else if currentSpeakersViewModel.doctorsIsEmpty {
                    DoctorsEmpty()
                } else {
                    if currentSpeakersViewModel.speakersData!.isEmpty {
                        Text("Вы не добавили ни одного устройства, перейдите во вкладку \"Добавить\" для инициализации нового устройства.")
                            .foregroundColor(.gray)
                    } else {
                        if #available(iOS 15.0, *) {
                            NavigationView {
                                ScrollView { scrollViewContents }
                            }
                            .refreshable { currentSpeakersViewModel.fetchData() }
                        } else {
                            NavigationView {
                                ScrollView { scrollViewContents }
                            }
                        }
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
    
    var scrollViewContents: some View {
        VStack {
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

struct DoctorsEmpty: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("У вас нет ни одного контракта.")
                .font(.title2)
                .fontWeight(.bold)
            Text("Сначала откройте активный контракт с доктором.")
                .font(.body)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
                .padding(.leading, 40)
                .padding(.trailing, 40)
        }
    }
}


struct SpeakerItem: View {
    let speaker: SpeakerData
    
    var body: some View {
        VStack {
            HStack {
                Image("speaker")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .padding()
                Text("Врач: \(speaker.doctorName)")
                    .padding()
            }
            Divider()
                .padding([.leading, .trailing])
        }
    }
}

struct SpeakerSettings: View {
    let speaker: SpeakerData
    
    @State private var showModal: Bool = false
    
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
            
            Section {
                Button("Cгенерировать пароль для Wi-Fi", action: {
                    showModal.toggle()
                })
                    .sheet(isPresented: $showModal, content: {
                        WifiSettingsModalView(code: speaker.speaker.code, isPresented: $showModal)
                    })
            }
        }
    }
}


struct WifiSettingsModalView: View {
    let code: String
    @Binding var isPresented: Bool
    
    @ObservedObject var generateCodeViewModel = GenerateCodeViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Button("Отмена", action: { isPresented.toggle() })
                Spacer()
            }
            .padding()
            Form {
                Section(header: Text("Настройки Wi-Fi")) {
                    TextField("Имя сети (SSID)", text: $generateCodeViewModel.ssid)
                    TextField("Пароль", text: $generateCodeViewModel.password)
                }
                
                Section {
                    if generateCodeViewModel.showLoader {
                        if generateCodeViewModel.playing {
                            HStack{
                                Text("Воспроизводится...")
                                    .padding([.trailing])
                                ProgressView()
                            }
                        } else {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    } else {
                        Button(action: generateButtonAction, label: { Text("Сгенерировать код") })
                            .disabled(generateButtonIsDisabled)
                    }
                }
            }
        }
    }
    
    func generateButtonAction() {
        generateCodeViewModel.generateCodeNoCreate(code: code)
    }
    
    var generateButtonIsDisabled: Bool {
        return generateCodeViewModel.ssid.isEmpty || generateCodeViewModel.ssid.isEmpty
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
