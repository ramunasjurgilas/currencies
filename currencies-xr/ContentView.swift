//
//  ContentView.swift
//  currencies-xr
//
//  Created by Ramunas Jurgilas on 2019-10-12.
//  Copyright © 2019 Ramūnas Jurgilas. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext)
    var viewContext   

    var body: some View {
        NavigationView {
            ExRateListView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
