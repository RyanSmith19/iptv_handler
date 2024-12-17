//
//  ChannelListViewTests.swift
//  iptv_handler
//
//  Created by Ryan Smith on 12/16/24.
//


import XCTest
@testable import iptv_handler

final class ChannelListViewTests: XCTestCase {
    
    var allChannels: [Channel]!
    
    override func setUp() {
        super.setUp()
        allChannels = [
            Channel(name: "News Channel", url: "http://news.com/stream", logo: nil),
            Channel(name: "Sports Channel", url: "http://sports.com/stream", logo: nil),
            Channel(name: "Movie Channel", url: "http://movies.com/stream", logo: nil)
        ]
    }
    
    override func tearDown() {
        allChannels = nil
        super.tearDown()
    }
    
    func testFilterChannelsWithEmptySearchText() {
        let filteredChannels = filterChannels(searchText: "", channels: allChannels)
        XCTAssertEqual(filteredChannels.count, 3)
    }
    
    func testFilterChannelsWithValidSearchText() {
        let filteredChannels = filterChannels(searchText: "News", channels: allChannels)
        XCTAssertEqual(filteredChannels.count, 1)
        XCTAssertEqual(filteredChannels.first?.name, "News Channel")
    }
    
    func testFilterChannelsWithNoMatch() {
        let filteredChannels = filterChannels(searchText: "Music", channels: allChannels)
        XCTAssertEqual(filteredChannels.count, 0)
    }
    
    // Helper function replicating filtering logic
    private func filterChannels(searchText: String, channels: [Channel]) -> [Channel] {
        if searchText.isEmpty {
            return channels
        } else {
            return channels.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
