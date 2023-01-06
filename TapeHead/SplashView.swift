//
//  SplashView.swift
//  TapeHead
//
//  Created by Hoang Linh Nguyen on 6/1/2023.
//

import SwiftUI
import Firebase



struct SplashView: View {
    @State private var isActive = false
    
    
//    let data = OurData()
//
//    init() {
//        FirebaseApp.configure()
//        data.loadAlbums()
//    }
    
   

    var body: some View {
        if isActive{
//            ContentView(data : data)
        }else{
            
            Color.black
                .edgesIgnoringSafeArea(.vertical)
                .overlay(
                    VStack(spacing: 20) {
                        Image("splash").resizable().frame(width: 170, height: 170, alignment: .center).clipped().cornerRadius(20).shadow(radius: 10)
                        Text("Tape Head").font(.custom("iCielCadena", size: 35)).foregroundColor(.white)
                    }.onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                            self.isActive = true
                        }
                    })
        }
            
            
        }
    }
    
    struct SplashView_Previews: PreviewProvider {
        static var previews: some View {
            SplashView()
        }
    }
