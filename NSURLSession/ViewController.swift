//
//  ViewController.swift
//  NSURLSession
//
//  Created by RISHOP BABU on 09/07/23.
//

import UIKit
import MobileCoreServices

typealias Parameters =  [String: String]

// Struct for Video
struct UploadData {
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
        //dataUpload()
        dataDownload()
    }
    
    private func dataUpload() {
        
        // Params if any
        let parameters = ["String": "String" ]
        
        /// Video upload
        let fileURL = URL(fileURLWithPath: "YOUR FILE PATH URL")
        guard let urlData = UploadData(withData: fileURL, forKey: "file") else { return }
        
        guard let url = URL(string: "YOUR URL") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = generateBoundary()
        let tokenStr = "Authorized Token if ANY"
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("jwt \(tokenStr)", forHTTPHeaderField: "Authorization")
        
        let dataBody = createDataBody(withParameters: parameters, media: urlData, boundary: boundary)
        request.httpBody = dataBody
        
        print(request.httpBody as Any)
        print(dataBody)
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    print(String(data: data, encoding: .utf8) as Any)
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
        
    }
    
    private func dataDownload() {
        
        // Params if any
        let parameters = ["String": "String" ]
        
        guard let url = URL(string: "YOUR SAMPLE URL") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let boundary = generateBoundary()
        let tokenStr = ""
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("jwt \(tokenStr)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                print("Received data: \(data)")
            }
        }.resume()
        
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
    func createDataBody(withParameters params: Parameters?, media: UploadData?, boundary: String) -> Data {

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
