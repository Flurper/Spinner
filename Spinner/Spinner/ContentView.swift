//
//  ContentView.swift
//  Spinner
//
//  Created by AM Student on 10/8/24.
//

import SwiftUI

struct ContentView: View {
    
    struct Leaf: View {
        let rotation: Angle
        let isCurrent: Bool
        let isCompleted: Bool
        
        
        
        var body: some View {
            Capsule()
                .stroke(isCurrent ? Color.white : Color.orange, lineWidth: 8)
                .frame(width: 20, height: isCompleted ? 20 : 50)
            //                .frame(width: 20, height: 50)
                .offset(
                    isCurrent
                    ? .init(width: 10, height: 0)
                    : .init(width: 40, height: 70))
            
                .scaleEffect(isCurrent ? 0.5 : 1)
                .rotationEffect(isCompleted ? .zero : rotation)
            //                .rotationEffect(rotation)
                .animation(.easeInOut(duration: 1.5), value: isCompleted)
        }
    }
    @State var currentIndex = -1
    @State var completed = false
    @State var isVisible = true
    @State var currentOffSet = CGSize.zero
    
    let shootUp = AnyTransition.offset(x: 0, y: -1000)
        .animation(.easeIn(duration: 1))
    
    var body: some View {
        VStack {
            if isVisible {
                ZStack {
                    ForEach(0..<12) { index in
                        Leaf(
                            rotation: .init(degrees: .init(index) / .init(12) * 360),
                            isCurrent: index == currentIndex,
                            isCompleted: completed
                        )
                    }
                }
                .offset(currentOffSet)
                .blur(radius: currentOffSet == .zero ? 0 : 10)
                .animation(.easeInOut(duration: 1))
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            currentOffSet = gesture.translation
                            
                        }
                        .onEnded { gesture in
                            if currentOffSet.height > 150 {
                                isCompleted()
                            }
                            currentOffSet = .zero
                        }
                )
                .transition(shootUp)
                .onAppear(perform: animate)
            }
        }
    }
    func isCompleted() {
        guard !completed else {
            return
        }
        completed = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            withAnimation {
                isVisible = false
            }
        }
    }
    func animate() {
        var iteration = 0
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
            currentIndex = (currentIndex + 1) % 12
            
            iteration += 1
            
            if iteration == 30 {
                timer.invalidate()
                completed = true
            }
        }
    }
}

#Preview {
    ContentView()
}
