//
//  ContentView.swift
//  Exam3_Waobikeze_Brian
//
//  Created by brian waobikeze on 11/16/23.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var imagearray:[UIImage] = [UIImage(named: "sample1")!,UIImage(named: "sample2")!,UIImage(named: "sample3")!]
    @State private var filterarr: [String] = ["Original", "Blur", "Binarized"]
    @State private var imageidx = 0;
    @State private var blurFilter = CIFilter.gaussianBlur()
    @State private var binarizeFilter = CIFilter.colorThreshold()
    @State private var filter: String = "Original"
    @State private var avatarImage: UIImage?
    @State private var intensity = 0.25
    @State private var tempImage: UIImage?
    let context = CIContext()
    var body: some View {
        VStack {
            Text("ML Model Vs Image Filters").font(Font.system(size: 25))
            Spacer()
        Picker(selection: $filter) {
            ForEach(filterarr, id: \.self) { filtered in
                Text("\(filtered)")
                            }
            } label: {
                            
            }.pickerStyle(.segmented)
                .onChange(of: filter) {
                    tempImage = imagearray[imageidx]
                    let beginImage = CIImage(image:imagearray[imageidx])
                    blurFilter.setValue(beginImage, forKey: kCIInputImageKey)
                    binarizeFilter.setValue(beginImage, forKey: kCIInputImageKey)
                    applyProcessing()
                }
            Image(uiImage: imagearray[imageidx])
                .resizable()
                .scaledToFit()
                //.aspectRatio(250.250, contentMode: .fill)

            HStack{
                Button(action: {}, label: {
                    Image(systemName: "photo")
                })
                Spacer()
                Button(action: {}, label: {
                    Text("+75%")
                })
                Spacer()

                Button(action: {
                    add25()
                }) {
                    Text("+25%")
                }//.disabled(filter == "Original")
            }.padding()
            Spacer()
            Spacer()
        }
        .padding()
    }
    func add25() {
//        if filter == "Binarized" {
//            let currentradius = binarizeFilter.threshold
//            binarizeFilter.threshold = currentradius * 0.25
//            guard let outputImage = binarizeFilter.outputImage else { return }
//            if let cgimage = context.createCGImage(outputImage, from: outputImage.extent) {
//                let uiimage = UIImage(cgImage: cgimage)
//                avatarImage = uiimage
//            }
//        }else if filter == "Blur" {
//            let currentradius = blurFilter.radius
//            blurFilter.radius = currentradius * 0.25
//            guard let outputImage = blurFilter.outputImage else { return }
//            if let cgimage = context.createCGImage(outputImage, from: outputImage.extent) {
//                let uiimage = UIImage(cgImage: cgimage)
//                avatarImage = uiimage
//            }
//            
//        }
        
    }
    func add75() {
        imagearray[imageidx] = tempImage ?? UIImage()
        return
    }
    func applyProcessing() {
        if filter == "Original" {
            return
        }else if filter == "Blur" {
            blurFilter.radius = Float(10*intensity)
            guard let outputImage = blurFilter.outputImage else { return }
            if let cgimage = context.createCGImage(outputImage, from: outputImage.extent) {
                let uiimage = UIImage(cgImage: cgimage)
                imagearray[imageidx] = uiimage
                //avatarImage = uiimage
            }
        } else if filter == "Binarized" {
            binarizeFilter.threshold = Float(0.5 * intensity)
            guard let outputImage = binarizeFilter.outputImage else { return }
            if let cgimage = context.createCGImage(outputImage, from: outputImage.extent) {
                let uiimage = UIImage(cgImage: cgimage)
                imagearray[imageidx] = uiimage
                //avatarImage = uiimage
            }
        }
    }
    
}

#Preview {
    ContentView()
}
