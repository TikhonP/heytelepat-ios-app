//
//  MainView.swift
//  Speaker
//
//  Created by Тихон on 19.08.2021.
//

import SwiftUI


struct MainView: View {
    @ObservedObject var networkMonitor: NetworkMonitor
    @ObservedObject var rootViewModel: RootViewModel
    
    var body: some View {
        TabView {
            SpeakersView()
                .tabItem {
                    Image(systemName: "eyes")
                    Text("Колонка")
                }
            ProfileView(rootViewModel: rootViewModel)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Профиль")
                }
        }
    }
}


#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(networkMonitor: NetworkMonitor(), rootViewModel: RootViewModel())
    }
}
#endif
