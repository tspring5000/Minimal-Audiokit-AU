import SwiftUI

struct MinimalAUMainView: View {
    var conductor: Conductor
    
    var body: some View {
        OscView(conductor: conductor)
    }
}
