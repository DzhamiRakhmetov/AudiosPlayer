import Foundation

class SongsProvider{
    
    static func configureSongs() -> [Song] {
        
        return [
        Song(
            name: "Take Me Back to London",
            author: "Ed Sheeran feat. Stormzy",
            fileName: "Ed Sheeran feat. Stormzy - Take Me Back to London (feat. Stormzy)",
            id: 1),
        Song(
            name: "Thunder",
            author: "Imagine Dragons",
            fileName: "Imagine Dragons - Thunder",
            id: 2),
        Song(
            name: "What I've Done",
            author: "Linkin Park",
            fileName: "Linkin Park - What I've Done",
            id: 3),
        Song(
            name: "Dani California",
            author: "Red Hot Chili Peppers",
            fileName: "Red Hot Chili Peppers - Dani California",
            id: 4),
        Song(
            name: "Is There Someone Else",
            author: "The Weeknd",
            fileName: "The Weeknd - Is There Someone Else",
            id: 5)]
    }
}
