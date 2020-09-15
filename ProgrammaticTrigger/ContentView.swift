//
//  ContentView.swift
//  ProgrammaticTrigger
//
//  Created by Thane Heninger on 9/15/20.
//

import Combine
import SwiftUI

// MARK: - Simple cancellable
struct SwiftUIViewH3: View {
    var body: some View {
        HStack {
            Text("simple cancellable")
            Spacer()
            ActionOnH3()
        }
        .padding()
    }
}

struct ActionOnH3: View {
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    @State private var topHalf = true
    var imageToDisplay: String {
        topHalf ? "circle.tophalf.fill" : "circle.bottomhalf.fill"
    }

    var body: some View {
        Image(systemName: imageToDisplay)
            .resizable()
            .frame(width: 64, height: 64)
            .onReceive(timer) { _ in
                topHalf.toggle()
            }
            .onTapGesture {
                timer.upstream.connect().cancel()
            }
    }
}

// MARK: - switch from outer class, toggle with id
struct SwiftUIViewH2: View {
    @State private var running = true
    var body: some View {
        HStack {
            Text("switch from outer class, toggle with id")
            Spacer()
            ActionOnH2(running: $running)
                .onTapGesture {
                    running.toggle()
                }
        }
        .padding()
    }
}

struct ActionOnH2: View {
    var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @Binding var running: Bool
    @State private var topHalf = true
    @State private var variableValueThatChanges = false
    @State private var refresh = 0
    
    var imageToDisplay: String {
        topHalf ? "circle.tophalf.fill" : "circle.bottomhalf.fill"
    }
    
    var body: some View {
        Image(systemName: imageToDisplay)
            .resizable()
            .frame(width: 64, height: 64)
            .onAppear {
                topHalf.toggle()
            }
        .id(refresh)
        .onReceive(timer) { _ in
            if running {
                refresh += 1
            }
        }
    }
}

// MARK: - toggle with timer onReceive
struct SwiftUIViewH1: View {
    @State var running = true
    var body: some View {
        HStack {
            Text("toggle with timer onReceive")
            Spacer()
            ActionOnH1(running: $running)
                .onTapGesture {
                    running.toggle()
                }
        }
        .padding()
    }
}

struct ActionOnH1: View {
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    @Binding var running: Bool
    @State private var topHalf = true
    
    var imageToDisplay: String {
        topHalf ? "circle.tophalf.fill" : "circle.bottomhalf.fill"
    }
    
    var body: some View {
        Image(systemName: imageToDisplay)
            .resizable()
            .frame(width: 64, height: 64)
            .onReceive(timer) { _ in
                if running {
                    topHalf.toggle()
                }
            }
    }
}

// MARK: - switch using ObservableObject
class windowActions: ObservableObject {
    @Published var running = true
    
    static let shared = windowActions()
}

struct SwiftUIViewH5: View {
    @ObservedObject var windows = windowActions.shared
    
    var body: some View {
        HStack {
            Text("switch using ObservableObject")
            Spacer()
            ActionOnH5()
                .onTapGesture {
                    windows.running.toggle()
                }
        }
        .padding()
    }
}

struct ActionOnH5: View {
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    @ObservedObject var windows = windowActions.shared
    
    @State private var topHalf = true
    var imageToDisplay: String {
        topHalf ? "circle.tophalf.fill" : "circle.bottomhalf.fill"
    }

    var body: some View {
        Image(systemName: imageToDisplay)
            .resizable()
            .frame(width: 64, height: 64)
            .onReceive(timer) { _ in
                if windows.running {
                    topHalf.toggle()
            }
        }
    }
}

// MARK: - switch using Combine publisher
fileprivate let switchPublisher1 = PassthroughSubject<Bool,Never>()

struct SwiftUIViewH4: View {
    @State private var running = true
    var body: some View {
        HStack {
            Text("switch using Combine publisher")
            Spacer()
            ActionOnH4()
                .onTapGesture {
                    running.toggle()
                    switchPublisher1.send(running)
                }
        }
        .padding()
    }
}

struct ActionOnH4: View {
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    @State private var topHalf = true
    @State private var running = true
    
    var imageToDisplay: String {
        topHalf ? "circle.tophalf.fill" : "circle.bottomhalf.fill"
    }

    var body: some View {
        Image(systemName: imageToDisplay)
            .resizable()
            .frame(width: 64, height: 64)
            .onReceive(timer) { _ in
                if running {
                    topHalf.toggle()
                }
            }
            .onReceive(switchPublisher1) { stateTo in
                running = stateTo
            }
    }
}

// MARK: - external timer
fileprivate let switchPublisher2 = PassthroughSubject<Bool,Never>()
fileprivate let timerPublisher = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

struct SwiftUIViewH6: View {
    @State private var running = true
    var body: some View {
        HStack {
            Text("external timer")
            Spacer()
            ActionOnH6()
                .onTapGesture {
                    running.toggle()
                    switchPublisher2.send(running)
                }
        }
        .padding()
    }
}

struct ActionOnH6: View {
    @State private var topHalf = true
    @State private var running = true
    
    var imageToDisplay: String {
        topHalf ? "circle.tophalf.fill" : "circle.bottomhalf.fill"
    }

    var body: some View {
        Image(systemName: imageToDisplay)
            .resizable()
            .frame(width: 64, height: 64)
            .onReceive(timerPublisher) { _ in
                if running {
                    topHalf.toggle()
                }
            }
            .onReceive(switchPublisher2) { stateTo in
                running = stateTo
            }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            SwiftUIViewH3()
            SwiftUIViewH2()
            SwiftUIViewH1()
            SwiftUIViewH5()
            SwiftUIViewH4()
            SwiftUIViewH6()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
