//
//  ContentView.swift
//  TapeHead
//
//  Created by Hoang Linh Nguyen on 22/12/2022.
//

import SwiftUI

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
}

struct ContentView: View {
     
    var albums = [Album(name: "Ngọt", image: "album1", songs: [Song(name: "Song 1", time: "1:00"),
        Song(name: "Song2", time: "1:00"),
        Song(name: "Song 3", time: "1:00")]),
    
                  Album(name: "Ngbthg", image: "album2", songs: [Song(name: "Song 1", time: "1:00"),
                      Song(name: "Song2", time: "1:00"),
                      Song(name: "Song 3", time: "1:00")]),
    
                  Album(name: "3 (tuyển tập nhạc Ngọt mới trẻ sôi động 2019)", image: "album3", songs: [Song(name: "Song 1", time: "1:00"),
                      Song(name: "Song2", time: "1:00"),
                      Song(name: "Song 3", time: "1:00")]),
    
                  Album(name: "Gieo", image: "album4", songs: [Song(name: "Song 1", time: "1:00"),
                      Song(name: "Song2", time: "1:00"),
                      Song(name: "Song 3", time: "1:00")])]
    
    var currentAlbum : Album?
    
    var body: some View {
        NavigationView{
            ScrollView{
                ScrollView(.horizontal, showsIndicators: false, content: {
                    LazyHStack{
                        ForEach(self.albums, id: \.self, content: {
                            album in
                            AlbumArt(album: album)
                            
                        })
                    }
                } )
                
            
                LazyVStack{
                    ForEach((self.currentAlbum?.songs ?? self.albums.first?.songs) ?? [Song(name: "Song 1", time: "1:00"),
                        Song(name: "Song2", time: "1:00"),
                        Song(name: "Song 3", time: "1:00")], id: \.self, content: {
                        song in
                        SongCell(song: song)
                    })
                }
            }
        }
    }
}

struct AlbumArt : View{
    var album : Album
    var body: some View{
        LazyVStack{
            Image(album.image).resizable().frame(width: 180, height: 180, alignment: .center).clipped().cornerRadius(20).shadow(radius: 10).padding(20)
            Text(album.name).frame(height: 30).foregroundColor(.black)
        }
        
    }
}

struct SongCell : View {
    var song : Song
    var body: some View{
        EmptyView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
