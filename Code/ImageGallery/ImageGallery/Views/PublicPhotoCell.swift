//
//  PublicPhotoCell.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 28/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import UIKit
/** Protocol to delegate the action of cell */
protocol PublicPhotoCellDelegate: class {
    func shareContent(for viewModel: ImageDetailViewModelProtocol?)
}
class PublicPhotoCell: UICollectionViewCell {
    // Outlets
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var publicImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var labelDatePublished: UILabel!
    @IBOutlet weak var labelDateTaken: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    // view model
    private var imageDetailViewModel: ImageDetailViewModelProtocol?
    // delegate
    weak var delegate: PublicPhotoCellDelegate?
    var index: Int? {
        didSet {
            self.setAccessibility()
        }
    }
    //MARK:- Lifecycle
    override func awakeFromNib() {
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        self.authorImageView.layer.cornerRadius = self.authorImageView.frame.size.width/2
        self.authorImageView.layer.masksToBounds = true
        
    }
    func setAccessibility() {
        guard let idx = index else { return }
        self.authorImageView.accessibilityIdentifier = "AuthorImageView_\(idx)"
        self.publicImageView.accessibilityIdentifier = "PublicPhotoImageView_\(idx)"
        self.authorLabel.accessibilityIdentifier = "AuthorLabel_\(idx)"
        self.titleLabel.accessibilityIdentifier = "TitleLabel_\(idx)"
        self.labelDatePublished.accessibilityIdentifier = "DatePublishedLabel_\(idx)"
        self.labelDateTaken.accessibilityIdentifier = "DateTakenLabel_\(idx)"
        self.shareButton.accessibilityIdentifier = "ShareButton_\(idx)"
    }
    //MARK:- Actions
    @IBAction func button_ShareClicked(_ sender: Any) {
        self.delegate?.shareContent(for: self.imageDetailViewModel)
    }
}
//MARK:- PublicPhotoCellProtocol implementation
extension PublicPhotoCell: PublicPhotoCellProtocol {
    // configure cell using view model
    func configure(using viewModel: ImageDetailViewModelProtocol) {
        self.imageDetailViewModel = viewModel
        self.authorLabel.text = viewModel.getAuthorName()
        self.titleLabel.text = viewModel.getTitle()
        self.publicImageView.image = nil
        self.publicImageView.image = UIImage(named: "PlaceholderImage")
        self.publicImageView.contentMode = .center
        self.labelDatePublished.text = ""
        self.labelDateTaken.text = ""
        
        if let datePublished = viewModel.getDatePublished() {
            if let publishedString = Utils.shared.getStringFrom(date: datePublished) {
                self.labelDatePublished.text = Constants.publishedPrefix + publishedString
            }
        }
        if let dateTaken = viewModel.getDateTaken() {
            if let takenString = Utils.shared.getStringFrom(date: dateTaken) {
                self.labelDateTaken.text = Constants.takenPrefix + takenString
            }
        }
        
        if let imageUrl = viewModel.getImageUrl()?.absoluteString {
            viewModel.getDownloadedImage(from: imageUrl, { (image) in
                DispatchQueue.main.async {
                    self.publicImageView.image = image
                    self.publicImageView.contentMode = .scaleAspectFit
                }
            })
        }
    }
}
