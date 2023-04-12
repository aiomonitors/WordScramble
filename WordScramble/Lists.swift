//
//  Lists.swift
//  WordScramble
//
//  Created by Shihab Chowdhury on 4/11/23.
//

import SwiftUI

struct ListGroupedExample: View {
    var body: some View {
        List {
            Section("Section 1") {
                Text("Static row 1")
                Text("Static row 2")
            }

            Section("Section 2") {
                ForEach(0..<5) {
                    Text("Dynamic row \($0)")
                }
            }

            Section("Section 3") {
                Text("Static row 3")
                Text("Static row 4")
            }
        }
        .listStyle(.grouped)
    }
}

struct Lists: View {
    var body: some View {
        List(0..<5) {
            Text("Dynamic row \($0)")
        }
    }
}

struct Lists_Previews: PreviewProvider {
    static var previews: some View {
        Lists()
        ListGroupedExample()
    }
}
