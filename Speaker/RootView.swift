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
    
    var body: some View {
        if rootViewModel.tokenExists {
            MainView(networkMonitor: networkMonitor, rootViewModel: rootViewModel)
                .transition(AnyTransition.scale.animation(.easeInOut(duration: 1)))
        } else {
            LoginView(networkMonitor: networkMonitor, rootViewModel: rootViewModel)
                .transition(AnyTransition.scale.animation(.easeInOut(duration: 1)))
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
