import SwiftUI

public protocol DSColorsProtocol {
    static var primary: Color { get }
    static var secondary: Color { get }
    static var background: Color { get }
    static var textDark: Color { get }
    static var textLight: Color { get }
}

public enum DSColorsLight: DSColorsProtocol {
    public static let primary = Color(red: 0x0A/255, green: 0xBA/255, blue: 0xB5/255) // Tiffany blue
    public static let secondary = Color(red: 0x0F/255, green: 0xC6/255, blue: 0xCC/255) // Aqua-ish
    public static let background = Color(red: 0xE3/255, green: 0xE7/255, blue: 0xEA/255) // Light gray
    public static let textDark = Color(red: 0x1A/255, green: 0x1A/255, blue: 0x1A/255)   // Almost black
    public static let textLight = Color.white
}

public enum DSColorsDark: DSColorsProtocol {
    public static let primary = Color(red: 0x08/255, green: 0x8A/255, blue: 0x86/255)   // Deeper teal
    public static let secondary = Color(red: 0x0D/255, green: 0x99/255, blue: 0x9F/255) // Muted aqua
    public static let background = Color(red: 0x12/255, green: 0x12/255, blue: 0x12/255) // Near black
    public static let textDark = Color(red: 0xE0/255, green: 0xE0/255, blue: 0xE0/255)   // Light gray for readability
    public static let textLight = Color.white
}
