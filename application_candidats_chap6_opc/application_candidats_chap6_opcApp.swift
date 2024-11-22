//
//  application_candidats_chap6_opcApp.swift
//  application_candidats_chap6_opc
//
//  Created by Hugues Bousselet on 22/11/2024.
//

import SwiftUI

@main
struct application_candidats_chap6_opcApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView(model: LoginOperation())
        }
    }
}
