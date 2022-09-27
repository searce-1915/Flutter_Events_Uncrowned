import 'package:linkedin_login/linkedin_login.dart';
import "package:flutter/material.dart";

class LinkedIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LinkedInUserWidget(
      appBar: AppBar(
        title: Text("LinkedIn"),
      ),
      destroySession: logoutUser,
      redirectUrl: ""
      clientId: "",
      clientSecret: "",
      projection: [
        ProjectionParameters.id,
        ProjectionParameters.localizedFirstName,
        ProjectionParameters.localizedLastName,
        ProjectionParameters.firstName,
        ProjectionParameters.lastName,
        ProjectionParameters.profilePicture,
      ],
      onGetUserProfile: (LinkedInUserModel linkedInUser) {},
    );
  }
}
