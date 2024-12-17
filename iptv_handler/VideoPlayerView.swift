//
//  VideoPlayerView.swift
//  iptv_handler
//
//  Created by Ryan Smith on 12/16/24.
//
import SwiftUI
import AVKit
import AVFoundation

struct VideoPlayerView: View {
    let channel: Channel
    
    @State private var player = AVPlayer()
    @State private var pipController: AVPictureInPictureController?
    @State private var isPlaying = true
    @State private var showControls = true
    
    var body: some View {
        VStack {
            ZStack {
                // Video Player
                VideoPlayer(player: player)
                    .onAppear { setupPlayer() }
                    .onTapGesture { withAnimation { showControls.toggle() } }
                
                if showControls {
                    VStack {
                        Spacer()
                        
                        // Playback Controls
                        HStack {
                            Button(action: { restartVideo() }) {
                                Image(systemName: "gobackward")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            
                            Button(action: { togglePlayPause() }) {
                                Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            
                            Spacer()
                            
                            // AirPlay Button
                            AirPlayButtonView()
                                .frame(width: 30, height: 30)
                                .padding()
                            
                            // PiP Button
                            Button(action: { startPiP() }) {
                                Image(systemName: "pip.enter")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                        .background(Color.black.opacity(0.5))
                    }
                }
            }
            
            // Channel Name
            Text(channel.name)
                .font(.headline)
                .padding()
        }
        .navigationTitle(channel.name)
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            player.pause()
            stopPiP()
        }
    }
    
    // MARK: - Player Setup and Controls
    
    private func setupPlayer() {
        if let streamURL = URL(string: channel.url) {
            player.replaceCurrentItem(with: AVPlayerItem(url: streamURL))
            player.play()
        }
        setupPiP()
    }
    
    private func togglePlayPause() {
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }
    
    private func restartVideo() {
        player.seek(to: .zero)
        player.play()
        isPlaying = true
    }
    
    // MARK: - PiP Support
    
    private func setupPiP() {
        guard AVPictureInPictureController.isPictureInPictureSupported() else { return }
        let playerLayer = AVPlayerLayer(player: player)
        pipController = AVPictureInPictureController(playerLayer: playerLayer)
    }
    
    private func startPiP() {
        pipController?.startPictureInPicture()
    }
    
    private func stopPiP() {
        pipController?.stopPictureInPicture()
    }
}

