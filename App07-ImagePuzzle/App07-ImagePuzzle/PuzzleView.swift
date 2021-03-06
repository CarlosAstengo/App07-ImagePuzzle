//
//  ContentView.swift
//  App07-ImagePuzzle
//
//  Created by Carlos Astengo Macias on 18/10/21.
//

import SwiftUI
import MobileCoreServices

struct PuzzleView: View {
    
    @StateObject var dataModel = DataModel()
    @State var isCompleted = true
    
    var columns : [GridItem] = Array(repeating: .init(.flexible(), spacing: 0), count: 4)
    
    var body: some View {
        GeometryReader{ geo in
            NavigationView {
                VStack {
                    Button{
                        isCompleted = false
                        dataModel.images.shuffle()
                    } label : {
                        HStack {
                            Image(systemName: "shuffle")
                                .font(.largeTitle)
                            Text("Shuffle")
                                .font(.largeTitle)
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.purple)
                        .cornerRadius(20)
                    }
                    .padding(.top,100)
                    .padding(.bottom,20)
                    
                    LazyVGrid(columns: columns, spacing : 0){
                        ForEach(dataModel.images) { im in
                            if isCompleted{
                                Image(im.image)
                                    .resizable()
                                    .frame(width: (geo.size.width-20)/4, height: (geo.size.width-20)/4)

                            }
                            else {
                                Image(im.image)
                                    .resizable()
                                    .frame(width: (geo.size.width-20)/4, height: (geo.size.width-20)/4)
                                .overlay(
                                    Rectangle()
                                            .stroke(Color.black,lineWidth: isCompleted ? 0:1)
                                )
                                .onDrag {
                                    
                                    dataModel.currentImage = im
                                    
                                    return NSItemProvider(item: .some(URL(string: im.image)! as NSSecureCoding), typeIdentifier: String(kUTTypeURL))
                                }
                                .onDrop(of: [.url], delegate: DropViewDelegate(dataModel: dataModel,image: im,isCompleted: $isCompleted))
                        }
                        }
                    }
                    .padding(.horizontal,10)
                    Image(isCompleted ? "completed" : "Santa Cruz-Sunrise_Original")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width/2)
                        .padding(.top,20)
                    
                }
                .navigationBarTitle("Puzzle")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PuzzleView()
    }
}
