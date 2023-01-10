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

var timer = Timer()


struct PlayerView : View{
    var album : Album
    var song : Song
    @State var videoPlayerSlider: Float
    @State var videoPlayerLabel: String
    var currentIndex: Int
    
    
    
    
    @State var isPlaying : Bool = false
    
    var body: some View{
        ZStack{
            Image(album.image).resizable().edgesIgnoringSafeArea(.all)
            Blur(style: .dark).edgesIgnoringSafeArea(.all)
            VStack{
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
        
    }
    
    func previous(){
        
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
        self.videoPlayerSlider = Float(currentTimeInSeconds) // I don't think this is correct to show current progress, however, this update will fix the compile error
        
        // 3 My suggestion is probably to show current progress properly
        if let currentItem = player.currentItem {
            let duration = currentItem.duration
            if (CMTIME_IS_INVALID(duration)) {
                // Do sth
                print(self.videoPlayerSlider)
                return;
            }
            let currentTime = currentItem.currentTime()
            self.videoPlayerSlider = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
        }
        
    }
    
   
    
    
}
