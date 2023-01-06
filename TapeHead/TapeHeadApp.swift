//
//  TapeHeadApp.swift
//  TapeHead
//
//  Created by Hoang Linh Nguyen on 22/12/2022.
//

import SwiftUI
import Firebase

@main
struct TapeHeadApp: App {
    
    let data = OurData()

    init() {
        FirebaseApp.configure()
        data.loadAlbums()
    }
    var body: some Scene {
        WindowGroup {
//            SplashView()
            ContentView(data: data)
        }
    }
}
