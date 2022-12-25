//
//  Data.swift
//  TapeHead
//
//  Created by Hoang Linh Nguyen on 25/12/2022.
//

import Foundation
import SwiftUI

import Firebase

class OurData : ObservableObject{
    @Published public var albums = [Album]()
    
    func loadAlbums(){
        Firestore.firestore().collection("albums").getDocuments { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents{
                    print(document.data())
                    let name = document.data()["name"] as? String ?? "error"
                    let image = document.data()["image"] as? String ?? "album1"
                    let songs = document.data()["songs"] as? [String : [String : Any]]
                    
                    var songsArray = [Song]()
                    if let songs = songs {
                        for song in songs{
                            let songName = song.value["name"] as? String ?? "error"
                            let songTime = song.value["time"] as? String ?? "error"
                            let songFile = song.value["file"] as? String ?? "error"
                            songsArray.append(Song(name: songName, time: songTime, file: songFile))
                        }
                    }
                    self.albums.append(Album(name: name, image: image, songs: songsArray))
                }
            }else{
                print(error ?? "")
            }
        }
    }
}
