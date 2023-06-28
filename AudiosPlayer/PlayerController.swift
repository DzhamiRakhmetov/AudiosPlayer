import UIKit
import AVFoundation

final class PlayerController: UIViewController {
    
    private var audioPlayer: AudioPlayer { return AudioPlayer.shared }
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("╳ Close", for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var previousSongButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(systemName: "backward.end")
        button.setImage(buttonImage, for: .normal)
        button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        button.addTarget(self, action: #selector(previousSongTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nextSongButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(systemName: "forward.end")
        button.setImage(buttonImage, for: .normal)
        button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        button.addTarget(self, action: #selector(nextSongTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(systemName: "pause")
        button.setImage(buttonImage, for: .normal)
        button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var songNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Song Name"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Author"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var durationTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currentSongTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var songTimeSlider: UISlider = {
        let slider = UISlider()
        slider.setThumbImage(UIImage(), for: .normal)
        slider.setThumbImage(UIImage(), for: .highlighted)
        slider.minimumTrackTintColor = .blue
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpConstraints()
        audioPlayer.delegate = self
    }
    
    // MARK: - Helpers
    
    private func setUpConstraints() {
        [closeButton, previousSongButton, playButton, nextSongButton, songNameLabel, authorLabel, durationTimeLabel, currentSongTimeLabel, songTimeSlider ].forEach {view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            songNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            songNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            authorLabel.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor, constant: 15),
            authorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            currentSongTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            currentSongTimeLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 50),
            
            durationTimeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            durationTimeLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 50),
            
            songTimeSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            songTimeSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            songTimeSlider.topAnchor.constraint(equalTo: currentSongTimeLabel.bottomAnchor, constant: 20),
            
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: songTimeSlider.bottomAnchor, constant: 30),
            
            previousSongButton.topAnchor.constraint(equalTo: songTimeSlider.bottomAnchor, constant: 30),
            previousSongButton.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -40),
            
            nextSongButton.topAnchor.constraint(equalTo: songTimeSlider.bottomAnchor, constant: 30),
            nextSongButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 40)
            
        ])
    }
    
    // MARK: -  @objc func
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func previousSongTapped() {
        audioPlayer.previous()
    }
    
    @objc func nextSongTapped() {
        audioPlayer.next()
    }
    
    @objc func playButtonTapped() {
        let isPlaying = audioPlayer.play()
        let string = isPlaying ? "pause" : "play"
        let image = UIImage(systemName: string)
        playButton.setImage(image, for: .normal)
    }
}

// MARK: - Extensions

extension PlayerController: AudioPlayerDelegate {
    func playTrack(_ audioPlayer: AudioPlayer, track: Song, time: Float, currentTime: Float) {
        
        // setUp UI
        songNameLabel.text = track.name
        authorLabel.text = track.author
        
        let durationMinutes = Int(time / 60)
        let durationSeconds = Int(time) % 60
        durationTimeLabel.text = String(format: "%02d:%02d", durationMinutes, durationSeconds)
        
        let minutes = Int(currentTime / 60)
        let seconds = Int(currentTime) % 60
        currentSongTimeLabel.text = String(format: "%02d:%02d", minutes, seconds)
        
        songTimeSlider.value = currentTime / time
    }
}
