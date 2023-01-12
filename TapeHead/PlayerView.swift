//
//  PlayerView.swift
//  TapeHead
//
//  Created by Hoang Linh Nguyen on 23/12/2022.
//

import Foundation

import SwiftUI
import SwiftUIFontIcon


import Firebase
import FirebaseStorage
import AVFoundation

var player = AVPlayer()

var timer = Timer()


struct PlayerView : View{
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var album : Album
    @State var song : Song
    @State var videoPlayerSlider: Float
    @State var videoPlayerLabel: String
    @State var currentIndex: Int
 
    @State var isPlaying : Bool = false
    @State var isShuffle : Bool = false
    @State var isRepeat : Bool = false
    
    
    var body: some View{
        ZStack{
            Image(album.image).resizable().edgesIgnoringSafeArea(.all)
            Blur(style: .dark).edgesIgnoringSafeArea(.all)
            VStack{
                HStack {
                    HStack {
                        FontIcon.text(.materialIcon(code: .arrow_back), fontsize: 25, color: .white)
                    }.onTapGesture(perform: {
                        self.mode.wrappedValue.dismiss()
                    })
                    Spacer()
                    Text(album.name).font(.custom("CircularStd-Bold", size: 15)).foregroundColor(.white).multilineTextAlignment(.center)
                    Spacer()
                    FontIcon.text(.materialIcon(code: .more_horiz), fontsize: 25, color: .white)
                }.padding(.top, 20).padding(.horizontal, 20).frame(maxWidth: .infinity)
               
                Spacer()
                AlbumArt(album: album, isWithText: false)
                Text(song.name).font(.custom("CircularStd-Medium", size: 18)).foregroundColor(.white).multilineTextAlignment(.center).padding(.horizontal, 10)
                Spacer()
                
                Slider(value: $videoPlayerSlider){editing in
                    
                    player.currentItem?.seek(to: CMTimeMake(value: Int64(videoPlayerSlider * Float(song.duration)), timescale: 1))
                    
                }
                
                .padding(.horizontal)
                Text(self.videoPlayerLabel)
                
                ZStack{
                    Color.black.opacity(0.2).cornerRadius(20).shadow(radius: 10)
                    HStack{
                        Button(action: self.shuffle, label: {
                            Image(systemName: "shuffle.circle.fill").resizable()
                        }).frame(width: 40, height: 40, alignment: .center).padding(.trailing, 15).foregroundColor(isShuffle ? .blue : .white)
                        Button(action: self.previous, label: {
                            Image(systemName: "arrow.left.circle").resizable()
                        }).frame(width: 40, height: 40, alignment: .center).foregroundColor(.white).padding(.trailing, 15)
                        Button(action: self.playPause, label: {
                            Image(systemName: isPlaying ? "play.circle.fill" : "pause.circle.fill").resizable()
                        }).frame(width: 60, height: 60, alignment: .center).foregroundColor(.blue)
                        Button(action: self.next, label: {
                            Image(systemName: "arrow.right.circle").resizable()
                        }).frame(width: 40, height: 40, alignment: .center).foregroundColor(.white).padding(.leading, 15)
                        Button(action: self.replay, label: {
                            Image(systemName: "repeat.circle.fill").resizable()
                        }).frame(width: 40, height: 40, alignment: .center).padding(.leading, 15).foregroundColor(isRepeat ? .blue : .white)
                    }
                    
                    
                }.edgesIgnoringSafeArea(.bottom).frame(height: 150, alignment: .center)
                
            }
            
            
        }.navigationBarBackButtonHidden(true).onAppear(){
//            let storage = Storage.storage().reference(forURL: self.song.file)
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                updateVideoPlayerSlider()
            }
            let url = URL(string: self.album.songs[currentIndex].file)
            player = AVPlayer(url: url!)
            player.play()
         
//            storage.downloadURL { url, error in
//                if error != nil{
//                    print(error!)
//                }else{
//                    print(url?.absoluteString ?? "")
//
//                    player = AVPlayer(url: url!)
//
//                    player.play()
//
//                }
//            }
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
        self.song = self.album.songs[(currentIndex+1) % self.album.songs.count]
        let url = URL(string: self.album.songs[(currentIndex+1) % self.album.songs.count].file)
        self.currentIndex += 1
        player = AVPlayer(url: url!)
        player.play()
     
    }
    
    func previous(){

        self.song = self.album.songs[(currentIndex-1) % self.album.songs.count]
        let url = URL(string: self.album.songs[(currentIndex-1) % self.album.songs.count].file)
        self.currentIndex -= 1
        player = AVPlayer(url: url!)
        player.play()
        
    }
    
    func shuffle(){
        self.isShuffle.toggle()
    }
    
    func replay(){
        self.isRepeat.toggle()
    }
    
    
    func updateVideoPlayerSlider() {
        let currentTimeInSeconds = CMTimeGetSeconds(player.currentTime())
        
        let mins = currentTimeInSeconds / 60
        let secs = currentTimeInSeconds.truncatingRemainder(dividingBy: 60)
        let timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        self.videoPlayerLabel = "\(minsStr):\(secsStr)"
        self.videoPlayerSlider = Float(currentTimeInSeconds)
        
 
        if let currentItem = player.currentItem {
            let duration = currentItem.duration
            if (CMTIME_IS_INVALID(duration)) {
                print(self.videoPlayerSlider)
                return;
            }
            let currentTime = currentItem.currentTime()
            self.videoPlayerSlider = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
        }
        
    }
    
   
    
    
}
