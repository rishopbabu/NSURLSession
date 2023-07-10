//
//  ViewController.swift
//  NSURLSession
//
//  Created by RISHOP BABU on 09/07/23.
//

import UIKit

typealias Parameters =  [String: String]

// Struct for Video
struct UploadVideo {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String

    init?(withData url: URL?, forKey key: String) {
        self.key = key
        self.mimeType = "video/mp4"
        self.filename = "video.mp4"
        guard let data = try? Data(contentsOf: url ?? URL(fileURLWithPath: "")) else { return nil }
        self.data = data
    }
}

//Struct for Image
struct UploadImage {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String

    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "photo\(arc4random()).jpeg"
        guard let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        self.data = data
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func dataUpload() {
        
        let parameters = ["title": "sampletest",
                          "channelId": "61c2f3772e0cbd194220a30b",
                          "categoryId": "61cda3a28d78564104af13e8",
                          "subCategoryId": "61dc18a49264c843dc187dc3",
                          "tags": "Testtwotesttwo",
                          "isUploadedByFan": "false" ]
        
        /// Image want to upload
        let image = UIImage(named: "")
        guard let mediaImage = UploadImage(withImage: image ?? UIImage(), forKey: "file")  else { return }
    }


}


extension ViewController {
    
    /// Genetate Boundary
    /// - Returns: String
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    /// Create DataBody
    /// - Parameters:
    ///   - params: Parametes if any or Nil
    ///   - media: Type of struct
    ///   - boundary: Genetated Boundary
    /// - Returns: Data
    func createDataBody(withParameters params: Parameters?, media: UploadImage?, boundary: String) -> Data {

        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        if let media = media {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(media.key)\"; filename= \"\(media.filename)\"\(lineBreak)")
            body.append("Content-Type: \(media.mimeType + lineBreak + lineBreak)")
            body.append(media.data)
            body.append(lineBreak)
        }

        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    
}


extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
