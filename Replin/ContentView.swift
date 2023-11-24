//
//  ContentView.swift
//  Replin
//
//  Created by Julian on 21/11/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var selectedFolder: URL? = nil
    @State private var selectedFolderOpened: Bool = false
    @State private var filenames: [FileItem] = []

    func mostrarPanelSeleccionCarpeta() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        
        panel.begin { respuesta in
            if respuesta == .OK {
                // Obtener la URL de la carpeta seleccionada
                guard let carpetaURL = panel.urls.first else { return }
                selectedFolder = carpetaURL

                Task {
                    construirArbolDesdeDirectorio(carpetaURL)
                }
            }
        }
    }
    
    // Función para construir el árbol de archivos y carpetas
    func construirArbolDesdeDirectorio(_ directorio: URL) -> FileItem {
        let nodoRaiz = FileItem(name: directorio.lastPathComponent, url: directorio)
        construirArbolRecursivo(nodoRaiz, en: directorio)
        return nodoRaiz
    }
    
    let extractOnlyFilesOf = ["localeEs.ts", "es.ts", "localePt.ts", "pt.ts"]
    let excludeFolderNames = ["node_modules", ".git", ".husky"]

    // Función recursiva para construir el árbol
    func construirArbolRecursivo(_ nodo: FileItem, en directorio: URL) {
        do {
            let contenido = try FileManager.default.contentsOfDirectory(at: directorio, includingPropertiesForKeys: nil)
            
            for elemento in contenido {
                let nombre = elemento.lastPathComponent
                let isDirectory = (try? elemento.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false
                let nuevoNodo = FileItem(name: nombre, url: elemento)
                
                let allowFolder: Bool = isDirectory ? !excludeFolderNames.map {
                    $0.lowercased()
                }.contains(nombre.lowercased()) : false
                let allowFile: Bool = isDirectory ? false : (extractOnlyFilesOf.map {
                    $0.lowercased()
                }).contains(nombre.lowercased())

                if allowFile {
                    print("File name:", nombre)

                    filenames.append(nuevoNodo)
                } else if allowFolder {
                    // Llamada recursiva si es un directorio
                    construirArbolRecursivo(nuevoNodo, en: elemento)
                }
            }
        } catch {
            print("Error al acceder al contenido del directorio: \(error)")
        }
    }

    var body: some View {
        NavigationSplitView {
            if (filenames.isEmpty) {
                VStack {
                    Spacer()
                    Button("Seleccionar Carpeta") {
                        mostrarPanelSeleccionCarpeta()
                    }
                    Spacer()
                }
            } else {
                List {

                    Section {
                        ForEach(filenames) { item in
                            NavigationLink {
                                FileInspector(file: item)
                                    .navigationTitle(item.name)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(item.url.lastPathComponent).font(.body)
                                    Text(item.url.relativeString).font(.caption2).italic()
                                }
                            }
                        }
                    } header: {
                        Text(String(filenames.count) + " archivos")
                    }
                    /*
                    ForEach(items) { item in
                        NavigationLink {
                            Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        } label: {
                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                        }
                    }
                    .onDelete(perform: deleteItems) */
                }
                .navigationSplitViewColumnWidth(min: 180, ideal: 200)
                .toolbar {
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
