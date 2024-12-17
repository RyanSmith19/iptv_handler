//
//  VideoPlayerViewTests.swift
//  iptv_handler
//
//  Created by Ryan Smith on 12/16/24.
//


import XCTest
import AVKit
@testable import iptv_handler

final class VideoPlayerViewTests: XCTestCase {
    
    var player: AVPlayer!
    
    override func setUp() {
        super.setUp()
        let streamURL = URL(string: "http://example.com/stream")!
        player = AVPlayer(url: streamURL)
    }
    
    override func tearDown() {
        player = nil
        super.tearDown()
    }
    
    func testPlayerInitialization() {
        XCTAssertNotNil(player.currentItem, "Player should have a valid AVPlayerItem")
    }
    
    func testPlayPauseToggle() {
        player.play()
        XCTAssertEqual(player.timeControlStatus, .playing, "Player should be playing")
        
        player.pause()
        XCTAssertEqual(player.timeControlStatus, .paused, "Player should be paused")
    }
    
    func testRestartVideo() {
        let expectation = XCTestExpectation(description: "Seek to start")
        
        player.seek(to: .zero) { _ in
            XCTAssertEqual(self.player.currentTime(), CMTime.zero, "Player should seek to the beginning")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
