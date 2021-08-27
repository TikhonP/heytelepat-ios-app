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
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(networkMonitor: NetworkMonitor(), rootViewModel: RootViewModel())
    }
}
