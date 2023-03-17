import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


/*
* class myApp contains the widget of the root application (i.e what will  be run)
* @author: vilmos feher
*/
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NACHO App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:  MainPage(),
    );
  }
}

/*
* class MainPage serves as the initial page the user will see, and will be asked to login
* @author: vilmos feher
*/
class MainPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder<User?>( 
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData){ //if user has been logged in stay logged in
          return HomePage();
        }else{
          return LoginWidget(); //else bring them back to login page
        }
      }
    ),
  );
}

/*
* class LoginWidget contains the state for the instance
* @author: vilmos feher
*/
class LoginWidget extends StatefulWidget{
  @override 
  _LoginWidgetState createState() => _LoginWidgetState();
}

/*
* class LoginWidgetState contains the actual wdigets used in the instance
* @author: vilmos feher
*/
class _LoginWidgetState extends State<LoginWidget>{

  //variables used for data
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Color buttonBackroundColor = Color.fromARGB(255, 172, 180, 180);
  Color textColor =  Color.fromARGB(255, 63, 13, 13);
  Color iconColor = Color.fromARGB(255, 104, 0, 240);

  //get rid of memory alloacted to objects
  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //builds the widget as a singlechildscrollview
  @override
  Widget build(BuildContext context) => SingleChildScrollView (
    padding: EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 100, height: 40), //spacer
        Text('Welcome to NACHO Security system!', style: TextStyle(color: textColor, fontSize: 24), textAlign: TextAlign.center,),
        SizedBox(width: 100, height: 40), //spacer
        Text('Please enter your login information:', style: TextStyle(color: textColor, fontSize: 20), textAlign: TextAlign.center,),
        TextField( //textfield for email input
          controller: emailController,
          cursorColor: Colors.white,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: textColor, fontSize: 16)),
        ),
        SizedBox(height: 20), //spacer
        TextField( //textfield for password input
          controller: passwordController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(labelText: 'Password', labelStyle: TextStyle(color: textColor, fontSize: 16)),
          obscureText: true, //hide contents
        ),
        SizedBox(height: 20), //spacer
        ElevatedButton.icon(  //button for signing in
          style: ElevatedButton.styleFrom(backgroundColor: buttonBackroundColor,
            fixedSize: const Size(250, 50)),
          icon: Icon(Icons.lock_open_rounded, color: iconColor, size: 32),
          label: Text('Sign in', style: TextStyle(color: textColor, fontSize: 24),),
          onPressed: signIn,
        )
    ],),
  );
  
  //function for signing into firebase and authenticating it
  Future signIn() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

}

/*
* class HomePage contains the page that links you to the other pages where the user
* will be able to view their systems data
* @author: vilmos feher
*/
class HomePage extends StatelessWidget {
  HomePage({super.key});
  Color pageBackgroundColor = Color.fromARGB(255, 47, 69, 71);
  Color buttonBackroundColor = Color.fromARGB(255, 172, 180, 180);
  Color textColor =  Color.fromARGB(255, 63, 13, 13);
  Color iconColor = Color.fromARGB(255, 104, 0, 240);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('NACHO Home Page'),
        backgroundColor:pageBackgroundColor,
      ),
      body: Center( 
        child: Column(
          mainAxisAlignment:  MainAxisAlignment.spaceEvenly ,
          children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            Text('Welcome back: ', style: TextStyle(color: textColor, fontSize: 36, fontWeight: FontWeight.bold,)), //welcome back message
            IconButton( //button to direct the user to user settings
              icon: Icon(Icons.settings, color: iconColor, size: 42),  
              style: ElevatedButton.styleFrom(backgroundColor: buttonBackroundColor,
              fixedSize: const Size(50, 50)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserSettingsPage()),
                );
              },
            ),
          ],),
        Text( user.email!, style: TextStyle(color: textColor, fontSize: 28, fontWeight: FontWeight.bold,)), //displays the users email (change to name eventually)
        ElevatedButton.icon( //button to direct the user to the camera settings page
          icon: Icon(Icons.camera_indoor_rounded, color: iconColor, size: 50),
          style: ElevatedButton.styleFrom(backgroundColor: buttonBackroundColor,
          fixedSize: const Size(250, 75)),
          label: Text('CAMERAS', style: TextStyle(color: textColor, fontSize: 20)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CameraSettingPage()),
            );
          },
        ),
        ElevatedButton.icon( //button to direct the user to the live feed page
          icon: Icon(Icons.video_camera_back_rounded, color: iconColor, size: 50),
          style: ElevatedButton.styleFrom(backgroundColor: buttonBackroundColor,
          fixedSize: const Size(250, 75)),
          onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => LiveFeedPage()));
        }, label: Text('LIVE FEED', style: TextStyle(color: textColor,fontSize: 20))
        ),
        ElevatedButton.icon( //button to direct the user to the library page
          icon: Icon(Icons.library_books_rounded, color: iconColor, size: 50),
          style: ElevatedButton.styleFrom(backgroundColor: buttonBackroundColor,
          fixedSize: const Size(250, 75)),
          onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => LibraryPage()));
        }, label: Text('LIBRARY', style: TextStyle(color: textColor, fontSize: 20))
        ),
        ElevatedButton.icon( //button to sign out
          icon: Icon(Icons.arrow_back,color: iconColor, size: 20),
          style: ElevatedButton.styleFrom(backgroundColor: buttonBackroundColor,
          fixedSize: const Size(120, 40)),
          onPressed: () => FirebaseAuth.instance.signOut(),
          label: Text('Sign out', style: TextStyle(color: textColor, fontSize: 16)),
        ),
      ])
    ));
  }
}



/*
* class CameraSettingPage contains the settings for the cameras a user
* has on their system. the user will be able to edit parameters through here 
* @author: vilmos feher
*
*ignore: must_be_immutable
*/
class CameraSettingPage extends StatelessWidget {
  CameraSettingPage({super.key});
  Color pageBackgroundColor = Color.fromARGB(255, 47, 69, 71);
  Color buttonBackroundColor = Color.fromARGB(255, 172, 180, 180);
  Color textColor =  Color.fromARGB(255, 63, 13, 13);
  Color iconColor = Color.fromARGB(255, 104, 0, 240);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Settings'),
        backgroundColor: pageBackgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
        ElevatedButton.icon(
          icon: Icon(Icons.arrow_back, color: iconColor, size: 20),
          style: ElevatedButton.styleFrom(backgroundColor: buttonBackroundColor,
          fixedSize: const Size(125, 50)), 
          onPressed: () {
            Navigator.pop(context);
          },
          label: Text('Home', style: TextStyle(color: textColor, fontSize: 24)),
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.camera_indoor_rounded, color: iconColor, size: 40),
          style: ElevatedButton.styleFrom(backgroundColor: buttonBackroundColor,
          fixedSize: const Size(200, 75)),
          onPressed: (){
            //link to camera settings 1
          }, 
          label: Text('Camera 1',style: TextStyle(color: textColor, fontSize: 24))),
        ElevatedButton.icon(
          icon: Icon(Icons.camera_indoor_rounded, color: iconColor, size: 40),
          style: ElevatedButton.styleFrom(backgroundColor: buttonBackroundColor,
          fixedSize: const Size(200, 75)),
          onPressed: (){
            //link to camera settings 2
          }, 
          label: Text('Camera 2',style: TextStyle(color: textColor, fontSize: 24))),
        ElevatedButton.icon(
          icon: Icon(Icons.camera_indoor_rounded, color: iconColor, size: 40),
          style: ElevatedButton.styleFrom(backgroundColor: buttonBackroundColor,
          fixedSize: const Size(200, 75)),
          onPressed: (){
            //link to camera settings 3
          }, 
          label: Text('Camera 3',style: TextStyle(color: textColor, fontSize: 24))),
        ]),
      ),
    );
  }
}

/*
* class LiveFeedPage contains buttons with links to live video feeds of the users
* cameras
* @author: vilmos feher
*/
class LiveFeedPage extends StatelessWidget {
  LiveFeedPage({super.key});
  Color pageBackgroundColor = Color.fromARGB(255, 47, 69, 71);
  Color buttonBackroundColor = Color.fromARGB(255, 172, 180, 180);
  Color textColor =  Color.fromARGB(255, 63, 13, 13);
  Color iconColor = Color.fromARGB(255, 104, 0, 240);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Video Feed'),
        backgroundColor: pageBackgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
        ElevatedButton.icon(
          icon: Icon(Icons.arrow_back, color: iconColor, size: 20),
          style: ElevatedButton.styleFrom(backgroundColor: buttonBackroundColor,
          fixedSize: const Size(125, 50)), 
          onPressed: () {
            Navigator.pop(context);
          },
          label: Text('Home', style: TextStyle(color: textColor, fontSize: 24)),
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.photo_camera_front, color: iconColor, size: 40),
          style: ElevatedButton.styleFrom(backgroundColor: buttonBackroundColor,
          fixedSize: const Size(200, 75)),
          onPressed: (){
            //link to camera settings 1
          }, 
          label: Text('Camera 1',style: TextStyle(color: textColor, fontSize: 24))),
        ElevatedButton.icon(
          icon: Icon(Icons.photo_camera_front, color: iconColor, size: 40),
          style: ElevatedButton.styleFrom(backgroundColor: buttonBackroundColor,
          fixedSize: const Size(200, 75)),
          onPressed: (){
            //link to camera settings 2
          }, 
          label: Text('Camera 2',style: TextStyle(color: textColor, fontSize: 24))),
        ElevatedButton.icon(
          icon: Icon(Icons.photo_camera_front, color: iconColor, size: 40),
          style: ElevatedButton.styleFrom(backgroundColor: buttonBackroundColor,
          fixedSize: const Size(200, 75)),
          onPressed: (){
            //link to camera settings 3
          }, 
          label: Text('Camera 3',style: TextStyle(color: textColor, fontSize: 24))),
      ]),
      ),
    );
  }
}

/*
* class LibraryPage contains the users recorded data.
* displays the data as well (analyzing is done on firebase)
* @author: vilmos feher
*/
class LibraryPage extends StatelessWidget {
  LibraryPage({super.key});
  Color pageBackgroundColor = Color.fromARGB(255, 47, 69, 71);
  Color buttonBackroundColor = Color.fromARGB(255, 172, 180, 180);
  Color textColor =  Color.fromARGB(255, 63, 13, 13);
  Color iconColor = Color.fromARGB(255, 104, 0, 240);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Library'),
        backgroundColor: pageBackgroundColor,
      ),
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
        ElevatedButton.icon(
          icon: Icon(Icons.arrow_back, color: iconColor, size: 20),
          style: ElevatedButton.styleFrom(backgroundColor: buttonBackroundColor,
          fixedSize: const Size(125, 50)), 
          onPressed: () {
            Navigator.pop(context);
          },
          label: Text('Home', style: TextStyle(color: textColor, fontSize: 24)),
        ),
        Text('No items in library', style: TextStyle(color: textColor, fontSize: 24)),
        ],
        )
      ),
    );
  }
}

/*
* class UserSettingsPage contains the users settings
* the user will be able to modify various settings
* @author: vilmos feher
*/
class UserSettingsPage extends StatelessWidget{
  UserSettingsPage({super.key});
  final user = FirebaseAuth.instance.currentUser!;
  Color pageBackgroundColor = Color.fromARGB(255, 47, 69, 71);
  Color buttonBackroundColor = Color.fromARGB(255, 172, 180, 180);
  Color textColor =  Color.fromARGB(255, 63, 13, 13);
  Color iconColor = Color.fromARGB(255, 104, 0, 240);

  @override
  Widget build(BuildContext context){
      return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: pageBackgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Owner: '),
            Text(user.email!, style: TextStyle(color: textColor, fontSize: 28, fontWeight: FontWeight.bold,)),
            Text('Version : 1.3', style: TextStyle(color: textColor, fontSize: 28, fontWeight: FontWeight.bold,)),
          ],
        )
      ),
   );
  }
}