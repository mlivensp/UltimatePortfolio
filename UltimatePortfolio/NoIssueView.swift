//
//  NoIssueView.swift
//  UltimatePortfolio
//
//  Created by Michael Livenspargar on 6/29/24.
//

import SwiftUI

struct NoIssueView: View {
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        Text("No issue selected")
            .font(.title)
            .foregroundStyle(.secondary)
        
        Button("New Issue") {
            // new issue
        }
    }
}

#Preview {
    NoIssueView()
}
