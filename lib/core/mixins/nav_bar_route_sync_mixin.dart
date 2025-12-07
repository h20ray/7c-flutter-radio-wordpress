import 'package:flutter/widgets.dart';

import '../routes/app_routes.dart';
import '../widgets/floating_bottom_nav_bar.dart';

/// A mixin that provides automatic NavItem synchronization with the current route.
/// 
/// This mixin eliminates code duplication across pages that use FloatingBottomNavBar
/// by centralizing the route-to-NavItem mapping logic.
/// 
/// Usage:
/// ```dart
/// class _HomeScreenState extends State<HomeScreen> with NavBarRouteSyncMixin {
///   @override
///   NavItem get defaultNavItem => NavItem.home;
///   
///   @override
///   Widget build(BuildContext context) {
///     return FloatingBottomNavBar(
///       selectedItem: selectedNavItem,
///       onItemSelected: onNavItemSelected,
///     );
///   }
/// }
/// ```
mixin NavBarRouteSyncMixin<T extends StatefulWidget> on State<T> {
  NavItem _selectedNavItem = NavItem.home;
  
  /// The current selected NavItem, synchronized with the route.
  NavItem get selectedNavItem => _selectedNavItem;
  
  /// Override this to set the default NavItem for this page.
  /// This is used as the initial value before route synchronization.
  NavItem get defaultNavItem;
  
  @override
  void initState() {
    super.initState();
    _selectedNavItem = defaultNavItem;
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncNavItemWithRoute();
  }
  
  /// Synchronizes the NavItem state with the current route.
  /// Called automatically in didChangeDependencies.
  void _syncNavItemWithRoute() {
    if (!mounted) return;
    
    final route = ModalRoute.of(context);
    final routeName = route?.settings.name;
    final navItem = _navItemFromRouteName(routeName);
    
    if (navItem != null && navItem != _selectedNavItem) {
      setState(() {
        _selectedNavItem = navItem;
      });
    }
  }
  
  /// Callback for FloatingBottomNavBar.onItemSelected.
  /// Updates the local state (the actual navigation is handled by the navbar).
  void onNavItemSelected(NavItem item) {
    if (item != _selectedNavItem) {
      setState(() {
        _selectedNavItem = item;
      });
    }
  }
  
  /// Maps route names to NavItem values.
  /// Returns null for routes that don't map to a nav item.
  NavItem? _navItemFromRouteName(String? routeName) {
    switch (routeName) {
      case AppRoutes.home:
        return NavItem.home;
      case AppRoutes.radio:
        return NavItem.radio;
      case AppRoutes.news:
        return NavItem.news;
      case AppRoutes.shoutbox:
        return NavItem.shoutbox;
      case AppRoutes.profile:
        return NavItem.profile;
      default:
        return null;
    }
  }
}
