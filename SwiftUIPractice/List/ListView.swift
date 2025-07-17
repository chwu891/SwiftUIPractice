//
//  ListView.swift
//  SwiftUIPractice
//
//  Created by Chi-Hsien Wu on 7/10/25.
//

import SwiftUI

struct Ocean: Identifiable, Hashable {
    let name: String
    let id = UUID()
}

struct ListView: View {
    
    @State private var multiSelection = Set<UUID>()
    @State private var editMode: EditMode = .inactive
    
    @State private var oceans = [
        Ocean(name: "Pacific"),
        Ocean(name: "Atlantic"),
        Ocean(name: "Indian"),
        Ocean(name: "Southern"),
        Ocean(name: "Arctic")
    ]
    
    @State private var selectedOceans: [Ocean] = []
    
    @State private var searchText: String = ""
    
    private var filteredOceans: [Ocean] {
        if searchText.isEmpty {
            return oceans
        } else {
            return oceans.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List(selection: $multiSelection) {
                    Section("OCEAN") {
                        ForEach(filteredOceans) { ocean in
                            Text(ocean.name)
                                .listRowBackground(Color.white)
                                .swipeActions(edge: .leading) {
                                    Button {
                                        print("⭐️ Favorited: \(ocean.name)")
                                    } label: {
                                        Label("Favorite", systemImage: "star.fill")
                                    }
                                    .tint(.yellow)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        print("🗑 Deleted: \(ocean.name)")
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
//                        .onDelete { index in
//                            oceans.remove(atOffsets: index)
//                        }
                        .onMove { indices, newOffset in
                            oceans.move(fromOffsets: indices, toOffset: newOffset)
                        }
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search oceans")
                
                if !selectedOceans.isEmpty {
                    ForEach(selectedOceans) { ocean in
                        /*@START_MENU_TOKEN@*/Text(ocean.name)/*@END_MENU_TOKEN@*/
                    }
                }
            }
            .toolbar {
                EditButton()
            }
            .environment(\.editMode, $editMode)
            .onChange(of: editMode) { _, newMode in
                if newMode == .inactive {
                    selectedOceans = oceans.filter { multiSelection.contains($0.id) }
                } else {
                    multiSelection = Set(selectedOceans.map { $0.id })
                }
            }
        }
    }
}

#Preview {
    ListView()
}
