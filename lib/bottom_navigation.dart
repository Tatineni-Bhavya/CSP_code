import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import './home_screen.dart';
import './pedometer_screen.dart';
import './help_screen.dart';
import './water.dart';

class bottombar extends StatefulWidget {
  const bottombar({super.key});

  @override
  State<bottombar> createState() => _bottombarState();
}

class _bottombarState extends State<bottombar> {
   PersistentTabController _controller = PersistentTabController(initialIndex: 0); 

  

  // List of screens for each tab 

  List<Widget> _buildScreens(BuildContext context) { 

    return [ 

     MyHomePage(title: 'WellnessBreak',),  

     PedometerPage(), 

     know_water(),

      Help(), 

     

    ]; 

  } 

  

  // List of nav bar items (tabs) 

  List<PersistentBottomNavBarItem> _navBarsItems() { 

    return [ 

      PersistentBottomNavBarItem( 

        icon: Icon(Icons.home), 

        title: "HOME", 

        activeColorPrimary: Colors.white, 

        inactiveColorPrimary: Colors.black, 

      ), 

      PersistentBottomNavBarItem( 

        icon: Icon(Icons.directions_walk), 

        title: "MYSTEPS", 

        activeColorPrimary: Colors.white, 

        inactiveColorPrimary: Colors.black,

      ), 
      
       PersistentBottomNavBarItem( 

        icon: Icon(Icons.water_drop_outlined),  

        title: "WATER", 

        activeColorPrimary: Colors.white, 

        inactiveColorPrimary: Colors.black, 

      ), 

      PersistentBottomNavBarItem( 

        icon: Icon(Icons.assignment_late), 

        title: "HELP", 

        activeColorPrimary: Colors.white, 

        inactiveColorPrimary: Colors.black,

      ), 

    ]; 

  } 

  

  @override 

  Widget build(BuildContext context) { 

    return PersistentTabView( 

      context, 

      controller: _controller, 

      screens: _buildScreens(context), 

      items: _navBarsItems(), 

      hideNavigationBarWhenKeyboardAppears: true,

      backgroundColor: Colors.purple, 

      navBarStyle: NavBarStyle.style3,  

    ); 

  } 

} 

  



  


