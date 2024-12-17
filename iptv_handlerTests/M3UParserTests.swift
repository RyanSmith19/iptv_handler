//
//  M3UParserTests.swift
//  iptv_handler
//
//  Created by Ryan Smith on 12/16/24.
//


import XCTest
@testable import iptv_handler

final class M3UParserTests: XCTestCase {
    
    var parser: M3UParser!
    
    override func setUp() {
        super.setUp()
        parser = M3UParser()
    }
    
    override func tearDown() {
        parser = nil
        super.tearDown()
    }
    
    func testParseValidM3UContent() {
        let m3uContent = """
        #EXTM3U
        #EXTINF:-1 tvg-logo="https://example.com/logo1.png",Channel 1
        http://stream-url1.com/stream
        #EXTINF:-1 tvg-logo="https://example.com/logo2.png",Channel 2
        http://stream-url2.com/stream
        """
        
        do {
            let channels = try parser.parse(m3uContent: m3uContent)
            XCTAssertEqual(channels.count, 2)
            XCTAssertEqual(channels[0].name, "Channel 1")
            XCTAssertEqual(channels[0].url, "http://stream-url1.com/stream")
            XCTAssertEqual(channels[0].logo, "https://example.com/logo1.png")
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }
    
    func testParseEmptyPlaylist() {
        let m3uContent = "#EXTM3U"
        
        XCTAssertThrowsError(try parser.parse(m3uContent: m3uContent)) { error in
            XCTAssertEqual(error as? M3UParserError, M3UParserError.emptyPlaylist)
        }
    }
    
    func testParseInvalidM3UContent() {
        let m3uContent = "INVALID DATA"
        
        XCTAssertThrowsError(try parser.parse(m3uContent: m3uContent)) { error in
            XCTAssertEqual(error as? M3UParserError, M3UParserError.emptyPlaylist)
        }
    }
}
