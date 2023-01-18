//
//  ContentView.swift
//  TapeHead
//
//  Created by Hoang Linh Nguyen on 22/12/2022.
//

import SwiftUI
import Firebase
import SwiftUIFontIcon
import AVFoundation

struct Album : Hashable{
    var id = UUID()
    var name : String
    var image : String
    var songs : [Song]
    var year : String
}

struct Song : Hashable{
    var id = UUID()
    var name : String
    var time : String
    var file : String
    var duration : Int
}

class GlobalVar: ObservableObject {
    @Published var isPlaying = false
    @Published var currentSongName = ""
    @Published var currentImage = ""
    @Published var isMiniPlay = false
    @Published var currentSongDuration = 0.0
    @Published var currentSongTime = 0.0

}



struct ContentView: View {
    
    @ObservedObject var data : OurData
    
    @State private var currentAlbum : Album?
    
    @State private var currentSong : Song?
    
    @StateObject var global = GlobalVar()
    
    @State var selectedSongItem: SongItem?
    
    @State var currentSongItem: SongItem?
    
    @State var isShowingSheet = false
    
    
    var body: some View {
        NavigationView{
            GeometryReader{
                let safeArea = $0.safeAreaInsets
                let size = $0.size
                VStack{
                    ScrollView(.vertical, showsIndicators: false){
                        VStack{
                            let height = size.height * 0.2
                            GeometryReader{proxy in
                                let minY = proxy.frame(in: .named("SCROLL")).minY
                                let progress = minY / (height * 0.8)
                                Image("cover")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipped()
                                    .cornerRadius(20)
                                    .shadow(radius: 10)
                                    .frame(width: proxy.size.width, height: proxy.size.height + (minY > 0 ? minY : 0))
                                    .overlay(content: {
                                        ZStack(alignment: .bottom){
                                            Rectangle()
                                                .fill(
                                                    .linearGradient(colors: [
                                                        .black.opacity(0 - progress),
                                                        .black.opacity(0.1 - progress),
                                                        .black.opacity(0.3 - progress),
                                                        .black.opacity(0.5 - progress),
                                                        .black.opacity(0.8 - progress),
                                                        .black.opacity(1 - progress),
                                                    ], startPoint: .top, endPoint: .bottom))
                                        }
                                    })
                                    .offset(y: -minY)
                                
                            }.frame(height: height + safeArea.top)
                            
                            
                            Text("TAPE HEAD").font(.custom("iCielCadena", size: 35)).foregroundColor(Color.white).padding(.bottom, 15)
                            
                            ScrollView(showsIndicators: false, content: {
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]
                                          , spacing: 20){
                                    ForEach(self.data.albums, id: \.self, content: {
                                        album in
                                        AlbumArt(album: album)
                                            .onTapGesture {
                                                self.currentAlbum = album
                                            }
                                            .background(self.currentAlbum == album ? .gray.opacity(0.3) : Color.black)
                                    })
                                }
                            }
                            ).padding(.horizontal, 20)
                            
                            TableHeader()

                            LazyVStack{
                                if self.data.albums.first == nil{
                                    EmptyView()
                                }
                                else{
                                    ForEach(0..<((self.currentAlbum?.songs.count ?? self.data.albums.first?.songs.count) ?? 0), id: \.self) {
                                        i in
                                        SongCell(album: self.currentAlbum ?? self.data.albums.first!, song: self.currentAlbum?.songs[i] ?? self.data.albums.first!.songs[i], index: i)
                                            .onTapGesture{
                                                selectedSongItem = SongItem(album: self.currentAlbum ?? self.data.albums.first!, song: self.currentAlbum?.songs[i] ?? self.data.albums.first!.songs[i], index: i)
                                                currentSongItem = SongItem(album: self.currentAlbum ?? self.data.albums.first!, song: self.currentAlbum?.songs[i] ?? self.data.albums.first!.songs[i], index: i)
                                            }
                                    }
                                    .sheet(item: $selectedSongItem){ item in
                                        PlayerView(album: item.album, song: item.album.songs[item.index], slider: 0, timeLabelLeft: "", timeLabelRight: "", currentIndex: item.index, playerActive: true)
                                    }
                                    .sheet(isPresented: $isShowingSheet){
                                        PlayerView(album: currentSongItem!.album, song: currentSongItem!.album.songs[currentSongItem!.index], slider: 0, timeLabelLeft: "", timeLabelRight: "", currentIndex: currentSongItem!.index, playerActive: false)
                                    }
                                }
                            }
                            .background(.black)
                            .clipped()
                            .cornerRadius(20)
                            .shadow(radius: 10)
                            
                        }
                        .background(Color.black.edgesIgnoringSafeArea(.all))
                    }
                    
                    if global.isMiniPlay{
                        Button(action:{
                            self.isShowingSheet.toggle()
                        }, label:{
                            MiniPlayer()
                        }
                        )
                    }
                }.foregroundColor(Color.white).ignoresSafeArea(.container, edges: .top)
            }.preferredColorScheme(.dark).coordinateSpace(name: "SCROLL")
        }
        .environmentObject(global)
        
        
    }
}


struct AlbumArt : View{
    var album : Album
    var body: some View{
        LazyVStack{
            Image(album.image).resizable()
                .frame(width: 150, height: 150, alignment: .center)
                .clipped()
                .cornerRadius(20)
                .shadow(color: .white, radius: 5)
                .padding(.horizontal, 20)
                .padding(.top, 5)
            Text(album.name).font(.custom("CircularStd-Bold", size: 18))
                .foregroundColor(Color.white)
                .lineLimit(1)
                .frame(width: 150, alignment: .leading)
            Spacer()
            Text("Ngọt | \(album.year)")
                .font(.custom("CircularStd-Medium", size: 13))
                .foregroundColor(Color.white.opacity(0.5))
                .frame(width: 150, alignment: .leading)
            Spacer()
            Text("\(album.songs.count) songs")
                .font(.custom("CircularStd-Medium", size: 13))
                .foregroundColor(Color.white.opacity(0.5))
                .frame(width: 150, alignment: .leading)
            Spacer()
        }
        .cornerRadius(10)
    }
   
}

struct SongItem : Identifiable {
    let id = UUID()
    var album : Album
    var song : Song
    var index: Int
}

struct TableHeader : View {
    var body: some View{
        VStack{
            HStack{
                Text("#")
                    .font(.custom("CircularStd-Bold", size: 15))
                    .foregroundColor(Color.white)
                    .padding(.trailing, 20)
                Text("TITLE")
                    .font(.custom("CircularStd-Bold", size: 15))
                    .foregroundColor(Color.white)
                Spacer()
                Image(systemName: "clock.fill")
                    .resizable()
                    .frame(width: 15, height: 15, alignment: .center)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            
            Rectangle()
                .fill(Color.white)
                .frame(height: 1)
                .padding(.top, 5)
                .padding(.horizontal, 20)
                .background(Color.black)
        }
       
    }
}

struct SongCell : View {
    var album : Album
    var song : Song
    var index: Int
    var body: some View{
        HStack{
            Text("\(index+1)").font(.custom("CircularStd-Bold", size: 15)).foregroundColor(Color.white).padding(.trailing, 20)
         
            Image(album.image).resizable().frame(width: 40, height: 40, alignment: .center).clipped()
        
            Text(song.name)
                .font(.custom("CircularStd-Medium", size: 15))
                .foregroundColor(Color.white)
                .hoverEffect(.lift)
            Spacer()
            Text(song.time).font(.custom("CircularStd-Medium", size: 15)).foregroundColor(Color.white)
        }
        .padding(20)
    }
    
    
}

struct MiniPlayer : View {
    @EnvironmentObject var global : GlobalVar
    var body : some View {
        ZStack{
            Color.black.opacity(0.2).cornerRadius(20).shadow(radius: 10)
            Image(global.currentImage).resizable().edgesIgnoringSafeArea(.all)
            Blur(style: .dark).edgesIgnoringSafeArea(.all)
            ProgressView(value: global.currentSongTime, total: global.currentSongDuration)
                .progressViewStyle(.linear)
                .frame(maxHeight: .infinity, alignment: .top)
                .tint(Color(UIColor(hexString: "#1DB954")))
            HStack{
                Image(global.currentImage).resizable().frame(width: 30, height: 30, alignment: .center).clipped()
                VStack(alignment: .leading){
                    Text(global.currentSongName)
                        .font(.custom("CircularStd-Bold", size: 15))
                        .foregroundColor(Color.white)
                        .hoverEffect(.lift)
                    Text("Ngọt")
                        .font(.custom("CircularStd-Medium", size: 12))
                        .foregroundColor(Color.white.opacity(0.5))
                        .hoverEffect(.lift)
                }
                
                Spacer()
                Button(action: self.playPause ,label: {
                    Image(systemName: global.isPlaying ? "play.fill" : "pause.fill").resizable()
                }).frame(width: 20, height: 20, alignment: .center).foregroundColor(.white)
                
            }.padding(.horizontal, 35)
        }
        .edgesIgnoringSafeArea(.bottom).frame(height: 35, alignment: .bottom)
        .onAppear{
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    global.currentSongTime = CMTimeGetSeconds(player.currentTime())
                }
            }
        
    }
    
    func playPause(){
        global.isPlaying.toggle()
        if global.isPlaying{
            player.pause()
        }else{
            player.play()
        }
    }
}



extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


struct ContentView_Previews : PreviewProvider{
    static var previews: some View{
        ContentView(data: OurData())
    }
}
