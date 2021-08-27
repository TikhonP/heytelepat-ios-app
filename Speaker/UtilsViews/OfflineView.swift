//
//  OfflineView.swift
//  Speaker
//
//  Created by Тихон on 27.08.2021.
//

import SwiftUI

struct OfflineView: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Устройство в режиме оффлайн")
                .font(.title2)
                .fontWeight(.bold)
            Text("Выключите Авиарежим или подключитесь к Wi-Fi.")
                .font(.body)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
                .padding(.leading, 40)
                .padding(.trailing, 40)
        }
    }
}

struct OfflineView_Previews: PreviewProvider {
    static var previews: some View {
        OfflineView()
    }
}
