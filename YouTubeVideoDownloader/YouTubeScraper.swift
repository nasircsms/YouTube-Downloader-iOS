//
//  YouTubeDownloader.swift
//  Pods
//
//  Created by Charlton Business on 12/28/16.
//
//

import Foundation
import TFHpple

final class YouTubeScraper {
    
    var parser: TFHpple?
    public func getDirectLink(fromPageSource source: String) -> URL? {
        
        if let string = getVideoAttribute(forKey: "src", source: source) as? String {
            if let url = URL(string: string) {
                return url
            }
        }
        return nil
    }
    
    public func getVideoTitle(fromPageSource source: String) -> String? {
        if let string = getVideoAttribute(forKey: "title", source: source) as? String {
            return string
        }
        return nil
    }
    
    public func getThumbnailImage(fromUrlString string: String) -> URL! {
        return imgUrl(getId(string))
    }
    
    private func imgUrl(_ idString: String) -> URL {
        let string = "https://img.youtube.com/vi/\(idString)/0.jpg"
        if let url = URL(string: string) {
            return url
        }
        return URL(string: "https://learn.getgrav.org/user/pages/11.troubleshooting/01.page-not-found/error-404.png")!
    }
    
    private func getId(_ string: String) -> String {
        guard let s = string.range(of: "watch?v=") else { return "JKYoutube Error: Not a valid YouTube URL" }
        let u = string.range(of: "watch?v=")!.upperBound
        let r = u..<string.endIndex
        return string.substring(with: r)
    }
    
    private func getVideoAttribute(forKey key: String, source: String) -> Any? {
        let htmlData = source.data(using: .utf8, allowLossyConversion: false)
        let parser = TFHpple(htmlData: htmlData)!
        self.parser = parser
        if let videos = parser.search(withXPathQuery: "//video") {
            for video in videos {
                if let string = (video as! TFHppleElement).attributes[key] as? String {
                    return string
                }
            }
        }
        return nil
    }
   
}
