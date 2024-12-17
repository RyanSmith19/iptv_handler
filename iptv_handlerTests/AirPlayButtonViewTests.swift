//
//  AirPlayButtonViewTests.swift
//  iptv_handler
//
//  Created by Ryan Smith on 12/16/24.
//


import XCTest
import AVKit
@testable import iptv_handler

final class AirPlayButtonViewTests: XCTestCase {
    
    func testAirPlayButtonView() {
        let airPlayButton = AirPlayButtonView()
        let view = airPlayButton.makeUIView(context: UIViewRepresentableContext<AirPlayButtonView>())
        
        XCTAssertNotNil(view, "AVRoutePickerView should be initialized")
        XCTAssertTrue(view is AVRoutePickerView, "View should be of type AVRoutePickerView")
    }
}
