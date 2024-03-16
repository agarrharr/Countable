import SwiftUI

struct CloseSheetButton: View {
    let callback: () -> Void
    
    var body: some View {
        Button {
            callback()
        } label: {
            Image(systemName: "xmark")
                .imageScale(.medium)
                .fontWeight(.bold)
                #if !os(visionOS)
                .foregroundColor(.gray)
                .padding(5)
                .background(Color.black.opacity(0.1))
                .clipShape(Circle())
                #endif
                .accessibility(label: Text("Close"))
                .accessibility(hint: Text("Double tap to close the sheet"))
        }
    }
}

#Preview {
    CloseSheetButton() {}
}
