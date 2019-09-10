//
//  Utils.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 28/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation
import UIKit
class Utils {
    // singleton object
    private static var _shared: Utils? = nil
    class var shared: Utils {
        guard let shared = _shared else {
            _shared = Utils()
            return _shared!
        }
        return shared
    }
    // private saved date formatters in order to improve performance. (initailized only once)
    private var dateTakenFormater: DateFormatter?
    private var datePublishedFormatter: DateFormatter?
    private var dateFormaterToString: DateFormatter?
    
    /**
     This method will return Date from date string (to be used for format of date taken).
     - Parameter dateTaken: date string of that date photos was taken.
     */
    func getDateFrom(dateTaken: String) -> Date? {
        if dateTakenFormater == nil {
            dateTakenFormater = DateFormatter()
            dateTakenFormater?.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        }
        return dateTakenFormater?.date(from: dateTaken)
    }
    /**
     This method will return Date from date string (to be used for format of date published).
     - Parameter datePublished: date string of that date photos was published.
     */
    func getDateFrom(datePublished: String) -> Date? {
        if datePublishedFormatter == nil {
            datePublishedFormatter = DateFormatter()
            datePublishedFormatter?.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        }
        return datePublishedFormatter?.date(from: datePublished)
    }
    /**
     This method will return String from Date (to be used for format to be displayed).
     - Parameter date: date to be converted to string
     */
    func getStringFrom(date: Date) -> String? {
        if dateFormaterToString == nil {
            dateFormaterToString = DateFormatter()
            dateFormaterToString?.dateFormat = "MMMM dd, YYYY"
        }
        return dateFormaterToString?.string(from: date)
    }
    /**
     This method is used to share the content using UIActivityViewController
     - Parameter content: content to be shared of type [Any].
     - Parameter controller: presenter of the activity.
     */
    func share(content: [Any], from controller: UIViewController) {
        let activityViewController = UIActivityViewController(activityItems: content, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = controller.view
        controller.present(activityViewController, animated: true, completion: nil)
    }
    /**
     This method will return height of the label based on the content string and font
     - Parameter text: string for which height is to be calculated
     - Parameter font: font of the text to be displayed
     - Parameter width: constrained width of the label
     */
    func heightFor(text: String?, font: UIFont, width: CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}
