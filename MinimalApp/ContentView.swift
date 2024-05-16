import SwiftUI

struct ContentView: View {
    var conductor = Conductor()
    
    var body: some View {
        OscView(conductor: conductor)
    }
}

#Preview {
    ContentView()
}
