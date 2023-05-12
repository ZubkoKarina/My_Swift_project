//
//  ModelsTableViewCell.swift
//  ios-model-kit
//
//  Created by Karina Zubko on 02.05.2023.
//

import UIKit
import Kingfisher

final class ModelsTableViewCell: UITableViewCell {
    
    @IBOutlet
    weak var previewImageView: UIImageView!
    
    @IBOutlet
    weak var previewTitleLabel: UILabel!
    
    @IBOutlet
    weak var previewDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }
    
    private func configure() {
        previewImageView.kf.indicatorType = .activity
    }
    
    func set(model: ModelsViewController.ModelStorage) {
        
        if let url = URL(string: model.imagePath) {
            previewImageView.kf.setImage(with: url)
        } else {
            previewImageView.image = UIImage(named: model.imagePath)
        }
        
        previewTitleLabel.text = model.title
        previewDescriptionLabel.text = model.description
    }
}
