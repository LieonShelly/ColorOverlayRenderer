//
//  ContentView.swift
//  ColorOverlayRenderer
//
//  Created by Renjun Li on 2026/4/9.
//

import SwiftUI

struct ContentView: View {
   
    @State var colorRenderer = ColorOverlayRenderer.shared
    @State private var red: Double = 1.0
    @State private var green: Double = 0.0
    @State private var blue: Double = 0.0
    @State var resultImage: UIImage?
    private var overlayColor: UIColor {
        UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    var body: some View {
        VStack {
//            Image(.dripper)
//                .background {
//                    Image(uiImage: colorRenderer.applyOverlay(to: UIImage(resource: .dripper), color: .red)!)
//                }
//
//            Image(uiImage: colorRenderer.applyOverlay(to: UIImage(resource: .cup), color: overlayColor)!)
            
            VStack {
                if let resultImage {
                    Image(uiImage: resultImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24)
                }
            }
           
            
            MTKViewRepresentable(renderer: colorRenderer)
            
            VStack(spacing: 12) {
                ColorSliderRow(label: "R", value: $red, tint: .red)
                ColorSliderRow(label: "G", value: $green, tint: .green)
                ColorSliderRow(label: "B", value: $blue, tint: .blue)
                Button("保存") {
                   resultImage = colorRenderer.exportCurrentResult()
                }
                
                Button("Clear") {
                    colorRenderer.cleanupRealtimeCache()
                }
            }
            .padding()
        }
        .onChange(of: overlayColor) { oldValue, newValue in
            colorRenderer.overlayColor = newValue
        }
        .onAppear {
            colorRenderer.prepareForRealtimeRendering(image: UIImage(resource: .dripper), expandRadius: 30)
            colorRenderer.overlayColor = .red
        }
    }
}


private struct ColorSliderRow: View {
    let label: String
    @Binding var value: Double
    let tint: Color
    
    var body: some View {
        HStack {
            Text(label)
                .frame(width: 20)
            Slider(value: $value, in: 0...1)
                .tint(tint)
            Text(String(format: "%.0f", value * 255))
                .frame(width: 40)
        }
    }
}
