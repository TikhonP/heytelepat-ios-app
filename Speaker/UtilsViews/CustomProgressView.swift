//
//  CustomProgressView.swift
//  Speaker
//
//  Created by Тихон on 27.08.2021.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
        VStack {
            ProgressView()
            Text("Загрузка")
                .foregroundColor(Color.gray)
        }
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView()
    }
}
