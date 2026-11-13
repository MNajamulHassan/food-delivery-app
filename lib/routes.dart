/// All named routes in one place, so we never mistype a route string.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String details = '/details'; // needs a FoodItem as argument
  static const String cart = '/cart';
  static const String address = '/address'; // returns the chosen address
  static const String about = '/about';
  static const String help = '/help';
}
