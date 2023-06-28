import UIKit
import AVFoundation

final class SongsController: UITableViewController {
    
    @IBOutlet var songsTableView: UITableView!
    
    private var audioPlayer: AudioPlayer { return AudioPlayer.shared}
    private var songs = [Song]()
    let cellID = "SongCell"
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        songs = SongsProvider.configureSongs()
    }
    
    // MARK: - Helpers
    
    func configureTableView() {
        songsTableView.delegate = self
        songsTableView.dataSource = self
        songsTableView.register(UINib(nibName: "SongCell", bundle: nil), forCellReuseIdentifier: cellID )
    }
    
    private func setupTimeTrack(track: Song) -> String {
        guard let urlString = Bundle.main.path(forResource:  track.fileName, ofType: "mp3")
        else { print("urlString is nil "); return "00:00"}
        
        let url = URL(fileURLWithPath: urlString)
        let asset = AVURLAsset(url: url)
        let duration = asset.duration
        let double = CMTimeGetSeconds(duration)
        
        let minutes = Int(double / 60)
        let seconds = Int(double) % 60
        return String(format: "%02d:%02d", minutes  , seconds)
    }
    
    // MARK: - TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! SongCell
        let time = setupTimeTrack(track: songs[indexPath.row])
        cell.setSong(song: songs[indexPath.row], time: time)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let playerController = PlayerController()
        let row = indexPath.row
        
        if !(audioPlayer.position == row) {
            audioPlayer.loadSongs(songs: songs)
            audioPlayer.playTrack(to: row)
        }
        
        self.present(playerController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
