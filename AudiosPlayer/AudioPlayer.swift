import Foundation
import AVFoundation

// MARK: - Protocol

protocol AudioPlayerDelegate: AnyObject {
    func playTrack(_ audioPlayer: AudioPlayer, track: Song, time: Float, currentTime: Float)
}

// MARK: - Class

final class AudioPlayer: NSObject {
    weak var delegate: AudioPlayerDelegate?
    static var shared: AudioPlayer = AudioPlayer()
    private var audioPlayer: AVAudioPlayer?
    private(set) var songs: [Song] = []
    var position: Int = 0
    var songData: Song? { return songs[position]}
    var timer: Timer? = nil
    
    private override init() {
        super.init()
        audioPlayer = AVAudioPlayer()
    }
    
    private func setupPlayer() {
        if songs.isEmpty {
            audioPlayer?.stop()
            removeTimer()
            return
        }
        
        let song = songs[position]
        let urlString = Bundle.main.path(forResource:  song.fileName, ofType: "mp3")
        guard let urlString = urlString else { print("urlString is nil "); return }
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            audioPlayer?.stop()
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
            audioPlayer?.delegate = self
            audioPlayer?.play()
            configureTimer()
        } catch  let error {
            print("error: ", error.localizedDescription)
        }
    }
    
    // MARK: - Helpers
    
    private func configureTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    private func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - @objc func
    
    @objc private func updateTime() {
        guard let audioPlayer = audioPlayer, let songData = songData else {
            removeTimer()
            return
        }
        
        let seconds = Float(audioPlayer.duration)
        let currentTime = Float(audioPlayer.currentTime)
        delegate?.playTrack(self, track: songData, time: seconds, currentTime: currentTime)
    }
}

//MARK: - AudioPlayer Extenstion

extension AudioPlayer: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            if position < (songs.count - 1) {
                position += 1
            } else {
                position = 0
            }
            setupPlayer()
        }
    }
    
    func playTrack(to row: Int) {
        if songs.count - 1 < row { return }
        position = row
        setupPlayer()
    }
    
    func loadSongs(songs array: [Song]) {
        self.songs = array
    }
    
    func previous() {
        if position > 0 {
            position -= 1
            setupPlayer()
        } else {
            position = songs.count - 1
            setupPlayer()
        }
    }
    
    func next() {
        if position < (songs.count - 1) {
            position += 1
            setupPlayer()
        } else {
            position = 0
            setupPlayer()
        }
    }
    
    func play() -> Bool {
        guard let audioPlayer = audioPlayer else {
            removeTimer()
            return false
        }
        
        if audioPlayer.isPlaying {
            removeTimer()
            audioPlayer.pause()
        } else {
            configureTimer()
            audioPlayer.play()
        }
        return audioPlayer.isPlaying
    }
}

