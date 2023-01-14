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
    
    @ObservedObject var data : OurData
    
    
    
    var body: some View {
        
        if isActive{
            ContentView(data : data).edgesIgnoringSafeArea(.top)
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


