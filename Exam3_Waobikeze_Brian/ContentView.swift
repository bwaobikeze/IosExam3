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
    @ObservedObject var classifier: ImageClassifier
    let context = CIContext()
    var body: some View {
        VStack {
            Text("TXT Recongnition Vs Image Filters").font(Font.system(size: 25))
            Spacer()
        Picker(selection: $filter) {
            ForEach(filterarr, id: \.self) { filtered in
                Text("\(filtered)")
                            }
            } label: {
                            
            }.pickerStyle(.segmented)
                .onChange(of: filter) {
                    let beginImage = CIImage(image: tempImage ?? UIImage())
                    blurFilter.setValue(beginImage, forKey: kCIInputImageKey)
                    binarizeFilter.setValue(beginImage, forKey: kCIInputImageKey)
                    applyProcessing()
                }
            Image(uiImage: imagearray[imageidx])
                .resizable()
                .scaledToFit()
                .onAppear{
                    classifier.detectTxt(uiImage: imagearray[imageidx] )
                    tempImage = imagearray[imageidx]
                }

            HStack{
                Button(action: {
                    randomImage()
                }, label: {
                    Image(systemName: "photo")
                })
                Spacer()
                Button(action: {
                    add75()
                }, label: {
                    Text("+75%")
                }).disabled(filter == "Original")
                Spacer()

                Button(action: {
                    add25()
                }) {
                    Text("+25%")
                }.disabled(filter == "Original")
            }.padding()
            Spacer()
            Group {
                if let imageClass = classifier.imageText {
                    HStack {
                        Text(imageClass)
                            .bold()
                            .lineLimit(10)
                    }
                    .foregroundStyle(.black)
                } else {
                    HStack {
                        Text("Unable to identify objects")
                            .font(.system(size: 26))
                    }
                    .foregroundStyle(.red)
                }
            }
            .font(.subheadline)
            .padding()
            Spacer()
        }
        .padding()
    }
    func randomImage(){
        let newIndex = Int.random(in: 0..<imagearray.count)
        imageidx = newIndex
        classifier.detectTxt(uiImage: imagearray[imageidx] )
        tempImage = imagearray[imageidx]
        applyProcessing()
    }
    func add25() {
        if filter == "Binarized" {
            let currentradius = binarizeFilter.threshold
            binarizeFilter.threshold = currentradius * 0.25
            guard let outputImage = binarizeFilter.outputImage else { return }
            if let cgimage = context.createCGImage(outputImage, from: outputImage.extent) {
                let uiimage = UIImage(cgImage: cgimage)
                imagearray[imageidx] = uiimage
            }
        }else if filter == "Blur" {
            let currentradius = blurFilter.radius
            blurFilter.radius = currentradius * 0.25
            guard let outputImage = blurFilter.outputImage else { return }
            if let cgimage = context.createCGImage(outputImage, from: outputImage.extent) {
                let uiimage = UIImage(cgImage: cgimage)
                imagearray[imageidx] = uiimage
            }
            
        }
        
    }
    func add75() {
                if filter == "Binarized" {
                    let currentradius = binarizeFilter.threshold
                    binarizeFilter.threshold = currentradius * 0.75
                    guard let outputImage = binarizeFilter.outputImage else { return }
                    if let cgimage = context.createCGImage(outputImage, from: outputImage.extent) {
                        let uiimage = UIImage(cgImage: cgimage)
                        imagearray[imageidx]  = uiimage
                    }
                }else if filter == "Blur" {
                    let currentradius = blurFilter.radius
                    blurFilter.radius = currentradius * 0.75
                    guard let outputImage = blurFilter.outputImage else { return }
                    if let cgimage = context.createCGImage(outputImage, from: outputImage.extent) {
                        let uiimage = UIImage(cgImage: cgimage)
                        imagearray[imageidx] = uiimage
                    }
        
                }
    }
    func applyProcessing() {
        if filter == "Original" {
            imagearray[imageidx] = tempImage ?? UIImage()
            return
        }else if filter == "Blur" {
            blurFilter.radius = Float(10*intensity)
            guard let outputImage = blurFilter.outputImage else { return }
            if let cgimage = context.createCGImage(outputImage, from: outputImage.extent) {
                let uiimage = UIImage(cgImage: cgimage)
                imagearray[imageidx] = uiimage
            }
        } else if filter == "Binarized" {
            binarizeFilter.threshold = Float(0.5 * intensity)
            guard let outputImage = binarizeFilter.outputImage else { return }
            if let cgimage = context.createCGImage(outputImage, from: outputImage.extent) {
                let uiimage = UIImage(cgImage: cgimage)
                imagearray[imageidx] = uiimage
            }
        }
    }
    
}

#Preview {
    ContentView(classifier: ImageClassifier())
}
