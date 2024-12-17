//
//  Channel.swift
//  iptv_handler
//
//  Created by Ryan Smith on 12/16/24.
//
import Foundation

struct Channel: Identifiable {
    let id = UUID()
    let name: String
    let url: String
    let logo: String?
}
