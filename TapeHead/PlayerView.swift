//
//  PlayerView.swift
//  TapeHead
//
//  Created by Hoang Linh Nguyen on 23/12/2022.
//

import Foundation

import SwiftUI

import Firebase
import FirebaseStorage
import AVFoundation

var player = AVPlayer()

struct PlayerView : View{
    var album : Album
    var song : Song
    
    
    
    @State var isPlaying : Bool = false
    
    var body: some View{
        ZStack{
            Image(album.image).resizable().edgesIgnoringSafeArea(.all)
            Blur(style: .dark).edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                AlbumArt(album: album, isWithText: false)
                Text(song.name).font(.title).fontWeight(.light).foregroundColor(.white)
                Spacer()
                ZStack{
                    Color.white.cornerRadius(20).shadow(radius: 10)
                    HStack{
                        Button(action: self.previous, label: {
                            Image(systemName: "arrow.left.circle").resizable()
                        }).frame(width: 50, height: 50, alignment: .center).foregroundColor(Color.black.opacity(0.2)).padding(.trailing, 15)
                        Button(action: self.playPause, label: {
                            Image(systemName: isPlaying ? "play.circle.fill" : "pause.circle.fill").resizable()
                        }).frame(width: 70, height: 70, alignment: .center).foregroundColor(.blue)
                        Button(action: self.next, label: {
                            Image(systemName: "arrow.right.circle").resizable()
                        }).frame(width: 50, height: 50, alignment: .center).foregroundColor(Color.black.opacity(0.2)).padding(.leading, 15)
                    }
                    
                }.edgesIgnoringSafeArea(.bottom).frame(height: 200, alignment: .center)
            }
            
            
        }.onAppear(){
            let storage = Storage.storage().reference(forURL: self.song.file)
            storage.downloadURL { url, error in
                if error != nil{
                    print(error!)
                }else{
                    print(url?.absoluteString ?? "")

                    player = AVPlayer(url: url!)
                    
                    player.play()
                   
                }
            }
        }
        
    }
    
    func playPause(){
        self.isPlaying.toggle()
        if isPlaying{
            player.pause()
        }else{
            player.play()
        }
    }
    
    func next() {
        
    }
    
    func previous(){
        
    }
}
