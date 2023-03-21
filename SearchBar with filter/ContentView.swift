//
//  ContentView.swift
//  SearchBar with filter
//
//  Created by Карина on 21.03.2023.
//

import SwiftUI

import SwiftUI

struct Pet: Identifiable {
    let id = UUID()
    let breed: String
    let gender: String
    let age: Int
    let city: String
}

struct ContentView: View {
    let pets = [
        Pet(breed: "Labrador Retriever", gender: "Male", age: 2, city: "New York"),
        Pet(breed: "Poodle", gender: "Female", age: 4, city: "Los Angeles"),
        Pet(breed: "German Shepherd", gender: "Male", age: 3, city: "Chicago"),
        Pet(breed: "Bulldog", gender: "Male", age: 1, city: "Houston"),
        Pet(breed: "Chihuahua", gender: "Female", age: 5, city: "Phoenix"),
        Pet(breed: "Beagle", gender: "Male", age: 2, city: "Philadelphia"),
        Pet(breed: "Boxer", gender: "Female", age: 4, city: "San Antonio"),
        Pet(breed: "Siberian Husky", gender: "Male", age: 3, city: "San Diego"),
        Pet(breed: "Dachshund", gender: "Male", age: 1, city: "Dallas"),
        Pet(breed: "Yorkshire Terrier", gender: "Female", age: 5, city: "San Jose")
    ]
    
    @State var searchText = ""
    @State var isFiltering = false
    @State var ageFilter = 0
    @State var genderFilter = "Any"
    @State var cityFilter = "Any"
    
    var filteredPets: [Pet] {
        var result = pets
        
        if !searchText.isEmpty {
            result = result.filter { $0.breed.localizedCaseInsensitiveContains(searchText) }
        }
        
        if ageFilter != 0 {
            result = result.filter { $0.age == ageFilter }
        }
        
        if genderFilter != "Any" {
            result = result.filter { $0.gender == genderFilter }
        }
        
        if cityFilter != "Any" {
            result = result.filter { $0.city == cityFilter }
        }
        
        return result
    }
    
    var body: some View {
        NavigationView {
            List {
              SearchBar(text: $searchText)
                
                ForEach(filteredPets) { pet in
                    VStack(alignment: .leading) {
                        Text(pet.breed)
                            .font(.headline)
                        Text("\(pet.gender), \(pet.age), \(pet.city)")
                            .font(.subheadline)
                    }
                }
            }
            .navigationBarTitle("Pets")
            .navigationBarItems(trailing:
                Button(action: {
                    self.isFiltering = true
                }) {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                }
            )
            .sheet(isPresented: $isFiltering) {
                FilterView(ageFilter: self.$ageFilter, genderFilter: self.$genderFilter, cityFilter: self.$cityFilter) {
                    self.isFiltering = false
                }
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search", text: $text)
                .foregroundColor(.primary)
                .keyboardType(.webSearch)
        }
        .padding(.vertical, 8)
        .background(Color(.systemGray5))
        .cornerRadius(8)
    }
}

struct FilterView: View {
    @Binding var ageFilter: Int
    @Binding var genderFilter: String
    @Binding var cityFilter: String
    
    var dismiss: () -> Void
    
    let ages = [0, 1, 2, 3, 4, 5, 6, 7 ]

    let genders = ["Any", "Male", "Female"]
    let cities = ["Any", "New York", "Los Angeles", "Chicago", "Houston", "Phoenix", "Philadelphia", "San Antonio", "San Diego", "Dallas", "San Jose"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Age")) {
                    Picker("Age", selection: $ageFilter) {
                        ForEach(ages, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Gender")) {
                    Picker("Gender", selection: $genderFilter) {
                        ForEach(genders, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("City")) {
                    Picker("City", selection: $cityFilter) {
                        ForEach(cities, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            .navigationBarTitle("Filter")
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.ageFilter = 0
                        self.genderFilter = "Any"
                        self.cityFilter = "Any"
                    }) {
                        Text("Clear")
                    },
                trailing:
                    Button(action: {
                        self.dismiss()
                    }) {
                        Text("Done")
                    }
            )
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


