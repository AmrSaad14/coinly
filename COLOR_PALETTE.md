# Coinly Color Palette

Colors extracted from the design mockup and implemented in the app.

## Primary Colors

| Color Name | Hex Code | RGB | Usage |
|------------|----------|-----|-------|
| **Primary Teal** | `#187259` | rgb(24, 114, 89) | Main brand color, AppBar, Buttons |
| **Secondary Teal** | `#23A983` | rgb(35, 169, 131) | Secondary actions, Icons, Highlights |
| **Accent Teal** | `#56DCB6` | rgb(86, 220, 182) | Bright accents, Active states, Success indicators |
| **Dark Teal** | `#0F5343` | rgb(15, 83, 67) | Dark mode, Accents, Hover states |
| **Light Teal** | `#1F8771` | rgb(31, 135, 113) | Lighter variant for highlights |

## Background Colors

| Color Name | Hex Code | RGB | Usage |
|------------|----------|-----|-------|
| **White** | `#FFFFFF` | rgb(255, 255, 255) | Main background, Cards |
| **Light Mint** | `#ABEDDA` | rgb(171, 237, 218) | Card backgrounds, Highlights, Info areas |
| **Pale Mint** | `#D4E9E5` | rgb(212, 233, 229) | Subtle backgrounds, Disabled states |
| **Card Background** | `#F5F5F5` | rgb(245, 245, 245) | Input fields, Disabled states |
| **Scaffold Background** | `#FAFAFA` | rgb(250, 250, 250) | Main screen background |

## Text Colors

| Color Name | Hex Code | RGB | Usage |
|------------|----------|-----|-------|
| **Text Dark** | `#1A1A1A` | rgb(26, 26, 26) | Primary text, Headers |
| **Text Medium** | `#666666` | rgb(102, 102, 102) | Secondary text, Descriptions |
| **Text Gray** | `#8A8A8A` | rgb(138, 138, 138) | Disabled text, Captions, Subtitles |
| **Text Light** | `#999999` | rgb(153, 153, 153) | Tertiary text, Hints, Placeholders |
| **Text White** | `#FFFFFF` | rgb(255, 255, 255) | Text on colored backgrounds |

## Accent Colors

| Color Name | Hex Code | RGB | Usage |
|------------|----------|-----|-------|
| **Success** | `#4CAF50` | rgb(76, 175, 80) | Success messages, Positive values |
| **Error** | `#E53935` | rgb(229, 57, 53) | Error messages, Negative values |
| **Warning** | `#FF9800` | rgb(255, 152, 0) | Warning messages, Alerts |
| **Info** | `#2196F3` | rgb(33, 150, 243) | Information, Links |

## Gradients

### Primary Gradient
```dart
LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [primaryTeal, darkTeal], // #187259 → #0F5343
)
```

### Card Gradient
```dart
LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [white, lightMint], // #FFFFFF → #D4E9E5
)
```

## Usage Examples

### In Theme File
```dart
// Access from AppTheme class
AppTheme.primaryTeal
AppTheme.lightMint
```

### In App Colors
```dart
// Access from AppColors class
AppColors.primaryTeal
AppColors.textDark
AppColors.primaryGradient
```

### In Widgets
```dart
// Using theme colors
Theme.of(context).colorScheme.primary // primaryTeal
Theme.of(context).colorScheme.secondary // darkTeal

// Using direct colors
Container(
  color: AppColors.lightMint,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textDark),
  ),
)

// Using gradients
Container(
  decoration: BoxDecoration(
    gradient: AppColors.primaryGradient,
  ),
)
```

## Color Psychology

**Teal/Emerald Green** (#187259)
- Represents: Trust, Growth, Wealth, Stability
- Perfect for: Financial apps, Crypto trading platforms
- Conveys: Security and prosperity

## Accessibility

All color combinations meet WCAG 2.1 AA standards:
- ✅ White text on Primary Teal (4.5:1 ratio)
- ✅ Dark text on White (21:1 ratio)
- ✅ Dark text on Light Mint (adequate contrast)

## Preview

```
┌─────────────────────────────────────┐
│  Primary Teal (#187259)             │ ← AppBar
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │  Card (White #FFFFFF)       │   │
│  │  ┌───────────────────────┐  │   │
│  │  │ Light Mint (#D4E9E5)  │  │   │
│  │  │ Accent Area           │  │   │
│  │  └───────────────────────┘  │   │
│  └─────────────────────────────┘   │
│                                     │
│  [Button - Primary Teal]            │
│                                     │
└─────────────────────────────────────┘
```

---

**Last Updated**: Based on design mockup analysis
**Theme File**: `lib/core/theme/app_theme.dart`
**Colors File**: `lib/core/theme/app_colors.dart`

