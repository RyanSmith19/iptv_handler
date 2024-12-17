//
//  ChannelListView.swift
//  iptv_handler
//
//  Created by Ryan Smith on 12/16/24.
//
import SwiftUI

struct ChannelListView: View {
    @State private var channels: [Channel] = []
    @State private var filteredChannels: [Channel] = []
    @State private var searchText: String = ""
    @State private var selectedChannel: Channel?
    @State private var errorMessage: String?
    @State private var isLoading: Bool = false
    
    let playlistURL = "https://example.com/your_playlist.m3u" // Replace with your M3U URL
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    TextField("Search channels...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .onChange(of: searchText) {
                            filterChannels()
                        }

                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            filterChannels()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                    }
                }
                
                if isLoading {
                    ProgressView("Loading Playlist...")
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    // Channel List
                    List(filteredChannels, id: \.id) { channel in
                        HStack {
                            if let logo = channel.logo, let url = URL(string: logo) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                } placeholder: { ProgressView() }
                            }
                            VStack(alignment: .leading) {
                                Text(channel.name)
                                    .font(.headline)
                                Text(channel.url)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .onTapGesture { selectedChannel = channel }
                    }
                }
            }
            .navigationTitle("IPTV Channels")
            .toolbar {
                // Settings Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                            .font(.title2)
                    }
                }
            }
            .onAppear(perform: loadChannels)
            .sheet(item: $selectedChannel) { channel in
                VideoPlayerView(channel: channel)
            }
        }
    }
    
    private func loadChannels() {
        guard let url = URL(string: playlistURL) else {
            errorMessage = "Invalid playlist URL."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    errorMessage = "Failed to load playlist: \(error.localizedDescription)"
                    return
                }
                guard let data = data, let content = String(data: data, encoding: .utf8) else {
                    errorMessage = "Unable to process playlist content."
                    return
                }
                
                let parser = M3UParser()
                do {
                    channels = try parser.parse(m3uContent: content)
                    filteredChannels = channels
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
        }.resume()
    }
    
    private func filterChannels() {
        if searchText.isEmpty {
            filteredChannels = channels
        } else {
            filteredChannels = channels.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}
