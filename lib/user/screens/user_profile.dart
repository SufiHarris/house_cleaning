// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:house_cleaning/user/screens/edit_profile.dart';
// import '../../auth/provider/auth_provider.dart';
// import '../../theme/custom_colors.dart';
// import '../widgets/custom_button_widget.dart'; // Import the combined widget file

// class UserProfile extends StatelessWidget {
//   const UserProfile({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final AuthProvider authProvider = Get.find<AuthProvider>();
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios, color: Color(0xFF6B3F3A)),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         title: Text(
//           'Profile',
//           style: TextStyle(color: Color(0xFF6B3F3A)),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: 20),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Stack(alignment: Alignment.center, children: [
//                     CircleAvatar(
//                       radius: 60,
//                       backgroundImage:
//                           AssetImage('assets/images/UserProfile-Pic.png'),
//                     ),
//                     const Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: CircleAvatar(
//                         backgroundColor: Color(0xFF6B3F3A),
//                         radius: 16,
//                         child: Icon(Icons.edit, size: 18, color: Colors.white),
//                       ),
//                     ),
//                   ]),
//                   SizedBox(height: 10),
//                   Text(
//                     "Jubayl Bin Meenak",
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           color: CustomColors.textColorThree,
//                         ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 30),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'Personal details',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Color(0xFF6B3F3A),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 readOnly: true,
//                 decoration: InputDecoration(
//                   hintText: 'Saad Al Nayem',
//                   labelStyle:
//                       const TextStyle(color: Color(0xFFDCD7D8), fontSize: 16),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                     borderSide: const BorderSide(color: Color(0xFFDCD7D8)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                     borderSide: BorderSide(color: CustomColors.textColorThree),
//                   ),
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'Phone Number',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Color(0xFF6B3F3A),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 readOnly: true,
//                 decoration: InputDecoration(
//                   hintText: 'Enter phone number',
//                   labelStyle:
//                       const TextStyle(color: Color(0xFFDCD7D8), fontSize: 16),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                     borderSide: const BorderSide(color: Color(0xFFDCD7D8)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                     borderSide: BorderSide(color: CustomColors.textColorThree),
//                   ),
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                   prefixIcon: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                         child: Text(
//                           '+1',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: CustomColors.textColorThree,
//                           ),
//                         ),
//                       ),
//                       VerticalDivider(
//                         color: CustomColors.textColorThree,
//                         thickness: 1,
//                         width: 1, // Minimal width for the divider
//                         indent: 12, // Optional, add spacing to top and bottom
//                         endIndent: 12,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'Email',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Color(0xFF6B3F3A),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 readOnly: true,
//                 decoration: InputDecoration(
//                   hintText: 'saadalnayem@gmail.com',
//                   labelStyle:
//                       const TextStyle(color: Color(0xFFDCD7D8), fontSize: 16),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                     borderSide: const BorderSide(color: Color(0xFFDCD7D8)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                     borderSide: BorderSide(color: CustomColors.textColorThree),
//                   ),
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                 ),
//               ),
//               SizedBox(height: 80),
//               Center(
//                 child: CustomButton(
//                   text: 'Edit',
//                   onTap: () {
//                     Get.to(() => EditProfile());
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/model/usermodel.dart';
import 'package:house_cleaning/user/screens/edit_profile.dart';
import '../../auth/provider/auth_provider.dart';
import '../../theme/custom_colors.dart';
import '../widgets/custom_button_widget.dart';
import '../../generated/l10n.dart'; // Import your localization file

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Get.find<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF6B3F3A)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          S.of(context).profile, // Localized app bar title
          style: TextStyle(color: Color(0xFF6B3F3A)),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<UserModel?>(
          future: getUserDetailsFromLocal(), // Fetch user details
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                  child: Text(S
                      .of(context)
                      .errorFetchingUserDetails)); // Localized error message
            }

            final user = snapshot.data;

            if (user == null) {
              return Center(
                  child: Text(S
                      .of(context)
                      .noUserDetailsFound)); // Localized no user message
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(alignment: Alignment.center, children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              AssetImage('assets/images/UserProfile-Pic.png'),
                        ),
                        const Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Color(0xFF6B3F3A),
                            radius: 16,
                            child:
                                Icon(Icons.edit, size: 18, color: Colors.white),
                          ),
                        ),
                      ]),
                      SizedBox(height: 10),
                      Text(
                        user.name, // Use the user's name
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: CustomColors.textColorThree,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S
                          .of(context)
                          .personalDetails, // Localized personal details title
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B3F3A),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: user.name, // Load name dynamically
                      labelStyle: const TextStyle(
                          color: Color(0xFFDCD7D8), fontSize: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Color(0xFFDCD7D8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            BorderSide(color: CustomColors.textColorThree),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).phoneNumber, // Localized phone number title
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B3F3A),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: user.phone, // Load phone number dynamically
                      labelStyle: const TextStyle(
                          color: Color(0xFFDCD7D8), fontSize: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Color(0xFFDCD7D8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            BorderSide(color: CustomColors.textColorThree),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              '+1',
                              style: TextStyle(
                                fontSize: 16,
                                color: CustomColors.textColorThree,
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: CustomColors.textColorThree,
                            thickness: 1,
                            width: 1, // Minimal width for the divider
                            indent:
                                12, // Optional, add spacing to top and bottom
                            endIndent: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).email, // Localized email title
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B3F3A),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: user.email, // Load email dynamically
                      labelStyle: const TextStyle(
                          color: Color(0xFFDCD7D8), fontSize: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Color(0xFFDCD7D8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            BorderSide(color: CustomColors.textColorThree),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                  ),
                  SizedBox(height: 80),
                  Center(
                    child: CustomButton(
                      text: S.of(context).edit, // Localized edit button text
                      onTap: () {
                        Get.to(() => EditProfile());
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
