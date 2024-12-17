//
//  AirPlayButtonView.swift
//  iptv_handler
//
//  Created by Ryan Smith on 12/16/24.
//
import SwiftUI
import AVKit

struct AirPlayButtonView: UIViewRepresentable {
    func makeUIView(context: Context) -> AVRoutePickerView {
        let airplayView = AVRoutePickerView()
        airplayView.activeTintColor = UIColor.white // AirPlay icon color when active
        airplayView.tintColor = UIColor.white // Default AirPlay icon color
        airplayView.backgroundColor = UIColor.clear
        return airplayView
    }
    
    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {}
}
