import UIKit

class SongCell: UITableViewCell {

    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setSong(song: Song, time: String){
        songNameLabel.text = "\(song.author) - \(song.name)"
        durationLabel.text = time
    }
}
