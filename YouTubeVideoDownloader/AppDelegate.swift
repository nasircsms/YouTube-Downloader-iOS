//
//  AppDelegate.swift
//  YouTubeVideoDownloader
//
//  Created by Charlton Provatas on 1/1/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import WKWebViewWithURLProtocol
import GCDWebServer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var webServer: GCDWebServer? = nil
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // application.setStatusBarHidden(true, with: .none)
        
        webServer = GCDWebServer()
        webServer?.addDefaultHandler(forMethod: "GET", request: GCDWebServerRequest.self, processBlock: { request in
            return GCDWebServerDataResponse(html: "<html><body><p>Hello World111</p></body></html>")
        })
        webServer?.start(withPort: 8081, bonjourName: nil)
        print("Visit \(webServer?.serverURL) in your web browser")
        
        URLProtocol.wk_registerScheme("http")
        URLProtocol.wk_registerScheme("https")
        URLProtocol.registerClass(WKTrafficManager.self)
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        try! AVAudioSession.sharedInstance().setActive(true)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if let avVc = application.avPlayerViewController() {
            avVc.toggleVideoOnAllTracks(false)
        }
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        YouTubeViewer.shared.backgroundCompletionHandler = completionHandler
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if let avVc = application.avPlayerViewController() {
            avVc.toggleVideoOnAllTracks(true)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}


fileprivate extension UIApplication {
    func hasAVPlayerViewControllerPresented() -> Bool {
        return keyWindow != nil
            && keyWindow!.rootViewController != nil
            && keyWindow!.rootViewController is UITabBarController
            && (keyWindow!.rootViewController as! UITabBarController).presentedViewController != nil
            && (keyWindow!.rootViewController as! UITabBarController).presentedViewController is AVPlayerViewController
    }
    
    func avPlayerViewController() -> AVPlayerViewController? {
        if !hasAVPlayerViewControllerPresented() { return nil }
        guard let tabBarController = keyWindow?.rootViewController as? UITabBarController else { return nil }
        return tabBarController.presentedViewController as? AVPlayerViewController
    }
}

fileprivate extension AVPlayerViewController {
    func toggleVideoOnAllTracks(_ enabled: Bool) {
        if UIApplication.shared.avPlayerViewController()!.player == nil
            || UIApplication.shared.avPlayerViewController()!.player!.currentItem == nil { return }
        
        let tracks = UIApplication.shared.avPlayerViewController()!.player!.currentItem!.tracks
        for track in tracks {
            // TODO: - isEnabled 작성
            if var track = track.assetTrack, track.hasMediaCharacteristic(.visual) {
                // track.isEnabled = enabled
            }
        }
    }
}
