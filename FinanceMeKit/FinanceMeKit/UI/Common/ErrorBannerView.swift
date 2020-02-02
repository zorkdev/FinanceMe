import SwiftUI

struct ErrorBannerView: View {
    @ObservedObject private var errorViewModel: ErrorViewModel
    @State private var offset: CGSize = .zero

    var body: some View {
        Group {
            if errorViewModel.error != nil {
                VStack(spacing: .zero) {
                    HStack {
                        Text(errorViewModel.icon!).font(.largeTitle)
                        Text(errorViewModel.description!).font(.callout).fontWeight(.medium)
                    }
                    .padding()
                    .frame(maxWidth: 500)
                    .foregroundColor(Color.white)
                    .background(Color(.systemRed))
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .offset(x: offset.width, y: offset.height)
                    .gesture(dragGesture)
                    .onTapGesture { self.errorViewModel.error = nil }

                    Spacer()
                }
                .padding([.top, .leading, .trailing])
                .transition(.move(edge: .top))
                .animation(.default)
            }
        }
    }

    init(_ errorViewModel: ErrorViewModel) {
        self.errorViewModel = errorViewModel
    }
}

private extension ErrorBannerView {
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { self.offset = $0.translation }
            .onEnded {
                if $0.translation.height < -10 {
                    self.errorViewModel.error = nil
                }
                self.offset = .zero
            }
    }
}

struct ErrorBannerContainerView<Presenting: View>: View {
    private let presenting: Presenting
    private let errorViewModel: ErrorViewModel

    var body: some View {
        ZStack {
            presenting
            ErrorBannerView(errorViewModel)
        }
    }

    init(_ errorViewModel: ErrorViewModel, presenting: Presenting) {
        self.errorViewModel = errorViewModel
        self.presenting = presenting
    }
}

extension View {
    func errorBanner(_ errorViewModel: ErrorViewModel) -> some View {
        ErrorBannerContainerView(errorViewModel, presenting: self)
    }
}
