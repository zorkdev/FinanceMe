#if os(macOS)
public typealias Color = NSColor
public typealias Font = NSFont
#elseif os(iOS) || os(watchOS) || os(tvOS)
public typealias Color = UIColor
public typealias Font = UIFont
#endif

public struct ColorPalette {

    public static let primary = Color(red: 27/255.0,
                                      green: 48/255.0,
                                      blue: 81/255.0,
                                      alpha: 1)
    public static let secondary = Color(red: 1/255.0,
                                        green: 164/255.0,
                                        blue: 219/255.0,
                                        alpha: 1)

    public static let lightText = Color(red: 242/255.0,
                                        green: 242/255.0,
                                        blue: 242/255.0,
                                        alpha: 1)
    public static let darkText = Color.darkGray

    public static let green = Color(red: 103/255.0,
                                    green: 184/255.0,
                                    blue: 82/255.0,
                                    alpha: 1)
    public static let red = Color(red: 209/255.0,
                                  green: 69/255.0,
                                  blue: 58/255.0,
                                  alpha: 1)

}
