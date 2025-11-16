# Cairo Font - Typography Guide

The Coinly app uses **Cairo** as its primary font family throughout the application.

## About Cairo Font

Cairo is a contemporary Arabic and Latin typeface family designed by Mohamed Gaber. It features:
- **Clean, Modern Design**: Perfect for financial and crypto applications
- **Excellent Readability**: Works great at all sizes
- **Multi-Script Support**: Supports both Arabic and Latin scripts
- **Multiple Weights**: From Light to Black (200-900)
- **Open Source**: Free to use via Google Fonts

## Implementation

The font is implemented using the `google_fonts` package:

```dart
import 'package:google_fonts/google_fonts.dart';

// In theme
fontFamily: GoogleFonts.cairo().fontFamily,
textTheme: GoogleFonts.cairoTextTheme(),
```

## Font Weights Available

| Weight | Value | Usage |
|--------|-------|-------|
| **Light** | 300 | Subtle text, decorative elements |
| **Regular** | 400 | Body text, default text |
| **Medium** | 500 | Emphasized text, card titles |
| **SemiBold** | 600 | Section headers, important info |
| **Bold** | 700 | Headlines, primary headers |
| **ExtraBold** | 800 | Hero text, main titles |
| **Black** | 900 | Display text, special emphasis |

## Usage Examples

### Basic Text

```dart
Text(
  'Welcome to Coinly',
  style: GoogleFonts.cairo(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
)
```

### Using Theme Text Styles

```dart
// Automatically uses Cairo font from theme
Text(
  'Body text',
  style: Theme.of(context).textTheme.bodyLarge,
)

Text(
  'Headline',
  style: Theme.of(context).textTheme.headlineMedium,
)
```

### Custom Styling

```dart
Text(
  'Total Balance',
  style: GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    letterSpacing: 0.5,
  ),
)
```

### Different Weights

```dart
// Light (300)
Text('Subtitle', style: GoogleFonts.cairo(fontWeight: FontWeight.w300))

// Regular (400)
Text('Body', style: GoogleFonts.cairo(fontWeight: FontWeight.w400))

// Medium (500)
Text('Card Title', style: GoogleFonts.cairo(fontWeight: FontWeight.w500))

// SemiBold (600)
Text('Section Header', style: GoogleFonts.cairo(fontWeight: FontWeight.w600))

// Bold (700)
Text('Headline', style: GoogleFonts.cairo(fontWeight: FontWeight.w700))
```

## Text Theme Hierarchy

The app's text theme uses Cairo font with the following hierarchy:

```dart
TextTheme(
  displayLarge: Cairo, size: 57, weight: 400
  displayMedium: Cairo, size: 45, weight: 400
  displaySmall: Cairo, size: 36, weight: 400
  
  headlineLarge: Cairo, size: 32, weight: 700
  headlineMedium: Cairo, size: 28, weight: 600
  headlineSmall: Cairo, size: 24, weight: 600
  
  titleLarge: Cairo, size: 22, weight: 500
  titleMedium: Cairo, size: 16, weight: 600
  titleSmall: Cairo, size: 14, weight: 500
  
  bodyLarge: Cairo, size: 16, weight: 400
  bodyMedium: Cairo, size: 14, weight: 400
  bodySmall: Cairo, size: 12, weight: 400
  
  labelLarge: Cairo, size: 14, weight: 500
  labelMedium: Cairo, size: 12, weight: 500
  labelSmall: Cairo, size: 11, weight: 500
)
```

## Typography Best Practices

### 1. **Use Theme Styles**
Always prefer theme text styles over hardcoded values:

```dart
// ✅ Good
Text('Hello', style: Theme.of(context).textTheme.bodyLarge)

// ❌ Avoid
Text('Hello', style: TextStyle(fontSize: 16))
```

### 2. **Hierarchy**
Maintain clear visual hierarchy:
- **Display**: Hero sections, splash screens
- **Headline**: Page titles, section headers
- **Title**: Card titles, dialog headers
- **Body**: Main content, descriptions
- **Label**: Buttons, chips, small UI elements

### 3. **Weight Usage**
- **Regular (400)**: Body text, paragraphs
- **Medium (500)**: Emphasized body text
- **SemiBold (600)**: Subsection headers
- **Bold (700)**: Main headers, CTAs

### 4. **Readability**
```dart
// Good line height for readability
Text(
  'Long paragraph text...',
  style: GoogleFonts.cairo(
    fontSize: 14,
    height: 1.5, // Line height
    letterSpacing: 0.25,
  ),
)
```

## Arabic Text Support

Cairo font has excellent Arabic script support:

```dart
Text(
  'مرحبا بك في كوينلي',
  style: GoogleFonts.cairo(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  ),
  textDirection: TextDirection.rtl,
)
```

## Performance Considerations

### Font Caching
Google Fonts automatically caches fonts for optimal performance:
- First load: Downloads from Google Fonts CDN
- Subsequent loads: Uses cached version
- No manual font file management needed

### Preloading (Optional)
For critical text, you can preload fonts:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Preload Cairo font
  await GoogleFonts.pendingFonts([
    GoogleFonts.cairo(),
  ]);
  
  runApp(const MyApp());
}
```

## Alternatives

If you need to use fonts offline or have custom requirements:

### Manual Font Files

1. Download Cairo font from [Google Fonts](https://fonts.google.com/specimen/Cairo)
2. Add to `assets/fonts/` directory
3. Update `pubspec.yaml`:

```yaml
flutter:
  fonts:
    - family: Cairo
      fonts:
        - asset: assets/fonts/Cairo-Regular.ttf
        - asset: assets/fonts/Cairo-Bold.ttf
          weight: 700
```

4. Use directly:

```dart
Text(
  'Hello',
  style: TextStyle(
    fontFamily: 'Cairo',
    fontSize: 16,
  ),
)
```

## Resources

- [Cairo Font on Google Fonts](https://fonts.google.com/specimen/Cairo)
- [Google Fonts Flutter Package](https://pub.dev/packages/google_fonts)
- [Material Design Typography](https://m3.material.io/styles/typography/overview)

---

**Current Font**: Cairo  
**Package**: google_fonts ^6.1.0  
**Theme File**: `lib/core/theme/app_theme.dart`

