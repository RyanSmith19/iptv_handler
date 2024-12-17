//
//  M3UParser.swift
//  iptv_handler
//
//  Created by Ryan Smith on 12/16/24.
//
import Foundation

enum M3UParserError: Error, LocalizedError {
    case invalidData
    case emptyPlaylist
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "The playlist data is invalid."
        case .emptyPlaylist:
            return "The playlist is empty."
        }
    }
}

class M3UParser {
    func parse(m3uContent: String) throws -> [Channel] {
        var channels: [Channel] = []
        var currentChannelName: String = ""
        var currentChannelLogo: String?
        
        let lines = m3uContent.components(separatedBy: .newlines)
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if trimmedLine.starts(with: "#EXTINF") {
                if let commaIndex = trimmedLine.range(of: ",") {
                    currentChannelName = String(trimmedLine[commaIndex.upperBound...])
                }
                
                if let logoRange = trimmedLine.range(of: "tvg-logo=\"") {
                    let startIndex = logoRange.upperBound
                    let endIndex = trimmedLine[startIndex...].range(of: "\"")?.lowerBound
                    currentChannelLogo = endIndex != nil ? String(trimmedLine[startIndex..<endIndex!]) : nil
                }
            } else if trimmedLine.hasPrefix("http") {
                let channel = Channel(name: currentChannelName, url: trimmedLine, logo: currentChannelLogo)
                channels.append(channel)
                currentChannelName = ""
                currentChannelLogo = nil
            }
        }
        
        guard !channels.isEmpty else {
            throw M3UParserError.emptyPlaylist
        }
        
        return channels
    }
    
}
