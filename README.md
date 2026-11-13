# Foodie Express 🛵

A food delivery app built in Flutter for **Mobile Application Development (MAD)**, Riphah International University, Faculty of Computing.
Instructor: Mr. Muhammad Usman.

The app is built up week by week. This version covers **Weeks 1–10**.

## Screens

| Screen | What it does |
|---|---|
| Splash | Animated logo, name and tagline, then opens Login or Home (if already logged in) |
| Login / Sign up | Form validation, show/hide password, account saved on the device |
| Home (4 tabs) | Notched bottom bar with Menu, Favourites, Orders, Profile and a docked cart button; side drawer |
| Menu tab | Search, promo banner, category chips, popular restaurants, food list, quick add to cart |
| Food details | Hero image animation, favourite toggle, description/ingredients toggle, quantity, add to cart |
| Cart | +/- per item, delivery address, bill summary, free delivery above Rs. 1500, place order |
| Address | Pick a saved address or type a new one; the choice is sent back to the previous screen |
| Orders tab | TabBar with Active and Past orders; orders move Preparing → On the way → Delivered |
| Favourites / Profile / Help / About | Saved dishes, user info and stats, FAQ, app info |

## Course topics used

| Week | Topic | Where in the code |
|---|---|---|
| 1 | Stateless & Stateful widgets, lifecycle | `SectionTitle`, `FoodCard` (stateless); `HomePage`, `SplashPage`, `LoginPage` (stateful, `initState` / `dispose`) |
| 2 | MaterialApp, theme, external packages | `main.dart`; `google_fonts`, `shared_preferences` |
| 3 | Dart basics: types, operators, `if`/`switch`, loops | `models/cart.dart`, `models/order.dart`, `models/menu_item.dart` |
| 4 | OOP: classes, constructors, getters/setters, inheritance | `MenuItem` (abstract) → `FoodItem`; `Restaurant.unknown()` named constructor; `AppStore` singleton (factory constructor); `AppUser` getters |
| 5–6 | Project structure | `models/`, `data/`, `services/`, `pages/`, `pages/tabs/`, `widgets/`, `theme/` |
| 7 | Scaffold, AppBar, SafeArea, Container, Text, RichText, Column, Row, buttons | All pages |
| 8 | AnimatedCrossFade, AnimatedOpacity, AnimationController, staggered animation | Splash; promo banner; cart empty state; details page |
| 10 | Navigator & named routes, passing and returning data | `routes.dart`, `routes:` + `onGenerateRoute` in `main.dart`; details gets a `FoodItem` argument; Address page returns a `String`; Cart returns `true` after an order |
| 10 | Hero animation | `FoodCard` → `FoodDetailPage` (`foodHeroTag`) |
| 10 | BottomAppBar with notch + docked FAB | `pages/home_page.dart` |
| 10 | TabBar + TabBarView | `pages/tabs/orders_tab.dart` |
| 10 | Drawer with a ListView menu | `widgets/app_drawer.dart` |
| 10 | ListView constructor for short lists | Favourites, Orders, Profile, Help, About, Address |

## Project structure

```
lib/
├── main.dart                  # MaterialApp, theme, named routes
├── routes.dart                # Route name constants
├── theme/app_colors.dart
├── models/
│   ├── menu_item.dart         # FoodCategory, MenuItem (abstract), FoodItem
│   ├── restaurant.dart
│   ├── cart.dart              # Cart, CartLine
│   ├── order.dart             # Order, OrderStatus
│   ├── app_user.dart
│   └── app_store.dart         # Shared app state (singleton)
├── services/auth_service.dart # Sign up / login with SharedPreferences
├── data/sample_data.dart
├── pages/
│   ├── splash_page.dart  login_page.dart  signup_page.dart
│   ├── home_page.dart         # Drawer + BottomAppBar + tabs
│   ├── tabs/ menu_tab.dart  favourites_tab.dart  orders_tab.dart  profile_tab.dart
│   ├── food_detail_page.dart  cart_page.dart  address_page.dart
│   └── about_page.dart  help_page.dart
└── widgets/ food_card.dart  restaurant_card.dart  category_chip.dart  section_title.dart  app_drawer.dart
test/ cart_test.dart  widget_test.dart
```

## Running it

```bash
# first time only: generate the android/ios/web folders
flutter create --project-name food_delivery_app --org com.riphah .

flutter pub get
flutter run
flutter test
```

Note: the account is stored locally with SharedPreferences (one account per device, password not encrypted). It gets replaced by Firebase Auth in week 14.

## Coming next

- Week 11: ListView.builder / GridView, cards, slivers
- Week 12: gestures, Dismissible to swipe items out of the cart, drag & drop
- Week 14: Firebase Auth + Firestore for menu and orders
