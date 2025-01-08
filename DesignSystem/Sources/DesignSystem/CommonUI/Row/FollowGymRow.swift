import SwiftUI
import Kingfisher

public struct FollowGymRow: View {
    var imageURL: String
    var name: String
    var followerCount: Int
    var isFollowing: Bool
    var keyword: String?
    var imageTapAction: (() -> Void)?
    var followTapAction: () -> Void
    
    private var btnTitle: String { isFollowing == true ? "팔로우" : "팔로잉" }
    
    public init(imageURL: String, name: String, followerCount: Int, isFollowing: Bool, keyword: String? = nil, imageTapAction: (() -> Void)? = nil, followTapAction: @escaping () -> Void) {
        self.imageURL = imageURL
        self.name = name
        self.followerCount = followerCount
        self.isFollowing = isFollowing
        self.keyword = keyword
        self.imageTapAction = imageTapAction
        self.followTapAction = followTapAction
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Button {
                imageTapAction?()
            } label: {
                KFImage(URL(string: imageURL))
                    .placeholder {
                        Image(.ellipse86)
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 41, height: 41)
                    .clipShape(.circle)
            }
            .disabled(imageTapAction == nil)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(name) { string in
                    string.foregroundColor = Color.levelWhite
                    string.font = Font.climeetFontParagraph2()
                    if let keyword,
                       let range = string.range(of: keyword) {
                        string[range].foregroundColor = Color.climeetMain
                    }
                }
                
                Text("팔로워 \(followerCount)")
                    .font(.climeetFontCaptionText2())
                    .foregroundStyle(Color.levelWhite)
            }
            
            Spacer()
            
            FollowButton(
                text: btnTitle,
                isFollow: isFollowing,
                action: followTapAction
            )
        }
    }
}
