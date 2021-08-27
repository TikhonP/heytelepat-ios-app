//
//  SpeakerApp.swift
//  Speaker
//
//  Created by Тихон on 19.08.2021.
//

import SwiftUI

let speakerServerDomain = "194.87.234.236"
let medsengerApiDomain = "medsenger.ru"
var medsengerApiKey: String? {
    return KeyChainTokenViewModel().token
}

@main
struct SpeakerApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
    }
}

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}
