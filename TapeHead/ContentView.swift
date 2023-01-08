//
//  ContentView.swift
//  TapeHead
//
//  Created by Hoang Linh Nguyen on 22/12/2022.
//

import SwiftUI
import Firebase
import SwiftUIFontIcon

struct Album : Hashable{
    var id = UUID()
    var name : String
    var image : String
    var songs : [Song]
}

struct Song : Hashable{
    var id = UUID()
    var name : String
    var time : String
    var file : String
    var duration : Int
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

struct ContentView: View {
    
    @ObservedObject var data : OurData
    
    @State private var currentAlbum : Album?
    
    
    
    var body: some View {
        NavigationView{
            GeometryReader{
                let safeArea = $0.safeAreaInsets
                let size = $0.size
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
                                .frame(width: proxy.size.width, height: proxy.size.height + (minY > 0 ? minY: 0))
                                .offset(y: -minY)
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

                        }.frame(height: height + safeArea.top)
                        
                        
                        Text("Welcome to Tape Head").font(.custom("CircularStd-Bold", size: 30)).foregroundColor(Color.white)
                        
                        ScrollView(.horizontal, showsIndicators: false, content: {
                            LazyHStack{
                                ForEach(self.data.albums, id: \.self, content: {
                                    album in
                                    AlbumArt(album: album, isWithText: true).onTapGesture {
                                        self.currentAlbum = album
                                    }
                                    
                                })
                            }
                        } )
                        
                        
                        LazyVStack{
                            if self.data.albums.first == nil{
                                EmptyView()
                            }
                            else{
                                ForEach((self.currentAlbum?.songs ?? self.data.albums.first?.songs) ?? [Song(name: "", time: "", file: "", duration: 0),
                                                                                                       ], id: \.self, content: {
                                    song in
                                    SongCell(album: self.currentAlbum ?? self.data.albums.first!, song: song)
                                    
                                    
                                })
                            }
                            
                            
                        }.background(Color(UIColor(hexString: "#1db954"))).clipped().cornerRadius(20).shadow(radius: 10)
                    }.background(Color.black.edgesIgnoringSafeArea(.all))
                }
            }.foregroundColor(Color.white).ignoresSafeArea(.container, edges: .top)
        }.preferredColorScheme(.dark).coordinateSpace(name: "SCROLL")
    }
}


struct AlbumArt : View{
    var album : Album
    var isWithText : Bool
    var body: some View{
        LazyVStack{
            Image(album.image).resizable().frame(width: 180, height: 180, alignment: .center).clipped().cornerRadius(20).shadow(radius: 10).padding(.horizontal, 20).padding(.top, 5)
            if isWithText == true {
                Text(album.name).font(.custom("CircularStd-Bold", size: 20)).foregroundColor(Color.white).lineLimit(1)
            }
            Spacer()
            
        }
        
    }
}

struct SongCell : View {
    var album : Album
    var song : Song
    var body: some View{
        NavigationLink(destination: PlayerView(album: album, song: song, videoPlayerSlider: 0, videoPlayerLabel: ""),
                       label: {
            HStack{
                FontIcon.text(.materialIcon(code: .play_arrow), fontsize: 25, color: .blue)
                Text(song.name).font(.custom("CircularStd-Medium", size: 15)).foregroundColor(Color.black).hoverEffect(.lift)
                Spacer()
                Text(song.time).font(.custom("CircularStd-Medium", size: 15)).foregroundColor(Color.black)
            }.padding(20)}).buttonStyle(PlainButtonStyle())
    }
    
    
}


struct ContentView_Previews : PreviewProvider{
    static var previews: some View{
        ContentView(data: OurData())
    }
}
