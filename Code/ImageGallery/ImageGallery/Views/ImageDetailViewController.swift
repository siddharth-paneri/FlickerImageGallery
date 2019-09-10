//
//  ImageDetailViewController.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 27/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {
    // otulets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageView_Author: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var takenDateLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var constraintPhotoTitleLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintPhotoTagsLabelHeight: NSLayoutConstraint!
    // view model
    var imageDetailViewModel: ImageDetailViewModelProtocol?
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAccessibility()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        // configure view using view model
        self.configure(using: imageDetailViewModel)
    }
    func setAccessibility() {
        self.imageView.accessibilityIdentifier = "PublicPhotoImageView"
        self.imageView_Author.accessibilityIdentifier = "AuthorImageView"
        self.authorLabel.accessibilityIdentifier = "AuthorLabel"
        self.descriptionLabel.accessibilityIdentifier = "DescriptionLabel"
        self.tagsLabel.accessibilityIdentifier = "TagsLabel"
        self.publishedDateLabel.accessibilityIdentifier = "DatePublishedLabel"
        self.takenDateLabel.accessibilityIdentifier = "DateTakenLabel"
        self.shareButton.accessibilityIdentifier = "ShareButton"
    }
    //MARK:- Actions
    @IBAction func buttonShareClicked(_ sender: Any) {
        // get content to share
        guard let shareContent = self.imageDetailViewModel?.getShareContent() else {
            return
        }
        // share content
        Utils.shared.share(content: shareContent, from: self)
    }
}
//MARK:- ImageDetailViewProtocol implementation
extension ImageDetailViewController: ImageDetailViewProtocol {
    func configure(using viewModel: ImageDetailViewModelProtocol?) {
        // setup image layer attributed
        self.imageView_Author.layer.cornerRadius = self.imageView_Author.frame.size.width/2
        self.imageView_Author.layer.masksToBounds = true
        // get the view model
        guard let vModel = viewModel else {
            // if view model is nill, do not show anything
            self.authorLabel.isHidden = true
            self.imageView.isHidden = true
            self.tagsLabel.text = ""
            self.descriptionLabel.isHidden = true
            self.publishedDateLabel.isHidden = true
            self.takenDateLabel.isHidden = true
            self.shareButton.isHidden = true
            return
        }
        // setup view items based on viewmodel properties
        self.authorLabel.text = vModel.getAuthorName()
        let title = vModel.getTitle()
        if title.isEmpty {
            self.descriptionLabel.text = "No title"
            self.descriptionLabel.textColor = UIColor.lightGray.withAlphaComponent(0.5)
        } else {
            self.descriptionLabel.text = "\(vModel.getTitle())"
            self.descriptionLabel.textColor = UIColor.gray
        }
        self.constraintPhotoTitleLabelHeight.constant =  Utils.shared.heightFor(text: self.descriptionLabel.text, font: self.descriptionLabel.font, width: self.descriptionLabel.frame.size.width)
        
        let tags = vModel.getTags()
        if tags.count == 0{
            self.tagsLabel.text = "No tags"
            self.tagsLabel.textColor = UIColor.lightGray.withAlphaComponent(0.5)
        } else {
            self.tagsLabel.text = "#\(vModel.getTags().joined(separator: " #"))"
            self.tagsLabel.textColor = UIColor.gray
        }
        self.constraintPhotoTagsLabelHeight.constant = Utils.shared.heightFor(text: self.descriptionLabel.text, font: self.descriptionLabel.font, width: self.descriptionLabel.frame.size.width)
        
        self.imageView.image = UIImage(named: "PlaceholderImage")
        self.imageView.contentMode = .center
        self.publishedDateLabel.text = ""
        self.takenDateLabel.text = ""
        // get date published
        if let datePublished = vModel.getDatePublished() {
            if let publishedString = Utils.shared.getStringFrom(date: datePublished) {
                self.publishedDateLabel.text = Constants.publishedPrefix + publishedString
            }
        }
        // get date taken
        if let dateTaken = vModel.getDateTaken() {
            if let takenString = Utils.shared.getStringFrom(date: dateTaken) {
                self.takenDateLabel.text = Constants.takenPrefix + takenString
            }
        }
        // get image from url or cahced directory
        if let imageUrl = vModel.getImageUrl()?.absoluteString {
            // mock data if we are performing UI tests
            if ProcessInfo.processInfo.arguments.contains("USE_MOCK_SERVER") {
                ImageDownloader(with: CommsProviderMock()).downloadImage(urlString: imageUrl) { (image, error) in
                    if error != nil {
                        // image loading error
                        return
                    }
                    DispatchQueue.main.async {
                        self.imageView.image = image
                        self.imageView.contentMode = .scaleAspectFit
                    }
                }
            } else {
                ImageDownloader(with: CommsProvider.shared).downloadImage(urlString: imageUrl) { (image, error) in
                    if error != nil {
                        // image loading error
                        return
                    }
                    DispatchQueue.main.async {
                        self.imageView.image = image
                        self.imageView.contentMode = .scaleAspectFit
                    }
                }
            }
            
        }
    }
}
