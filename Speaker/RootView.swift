//
//  RootView.swift
//  Speaker
//
//  Created by Тихон on 19.08.2021.
//

import SwiftUI


final class RootViewModel: ObservableObject {
    @Published var tokenExists: Bool = medsengerApiKey != nil
    
    func updateProperty() {
        self.tokenExists = medsengerApiKey != nil
    }
}

struct RootView: View {
    @ObservedObject var networkMonitor = NetworkMonitor()
    @ObservedObject var rootViewModel = RootViewModel()
    @ObservedObject var speakersViewModel = SpeakersViewModel()
    @ObservedObject var currentSpeakersViewModel = CurrentSpeakersViewModel()
    
    var body: some View {
        ZStack {
            if rootViewModel.tokenExists {
                mainView
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
            } else {
                LoginView()
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
            }
        }
        .environmentObject(networkMonitor)
        .environmentObject(rootViewModel)
        .environmentObject(speakersViewModel)
        .environmentObject(currentSpeakersViewModel)
    }
    
    var mainView: some View {
        TabView {
            CurrentSpeakers()
                .tabItem {
                    Image(systemName: "speaker.wave.2.circle.fill")
                    Text("Мои Устройства")
                }
            SpeakersView()
                .tabItem {
                    Image(systemName: "waveform.path.badge.plus")
                    Text("Добавить")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Профиль")
                }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
