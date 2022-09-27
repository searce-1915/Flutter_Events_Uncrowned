import "package:flutter/material.dart";

class FormScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FormScreenState();
}

class FormScreenState extends State<FormScreen> {
  late String _name;
  late String _email;
  late String _linkedInId;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _nameField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Name"),
      validator: (String? value) {
        if (value == null) {
          return "Name is required";
        }

        if (value.isEmpty) {
          return "Required";
        }

        return null;
      },
      onSaved: (newValue) {
        _name = newValue!;
      },
    );
  }

  Widget _emailField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Email"),
      validator: (String? value) {
        if (value == null) {
          return null;
        }
        if (value.isEmpty) {
          return "Required";
        }
        return null;
      },
      onSaved: (newValue) {
        _email = newValue!;
      },
    );
  }

  Widget _linkedInIdField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "LinkedIn Id"),
      validator: (value) {
        if (value == null) {
          return "Linkedin Id is required";
        }

        if (value.isEmpty) {
          return "Required";
        }

        return null;
      },
      onSaved: (newValue) {
        _linkedInId = newValue!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration Form"),
      ),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _nameField(),
                _emailField(),
                _linkedInIdField(),
                const SizedBox(
                  height: 100,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      _formKey.currentState!.save();

                      Navigator.pushNamed(context, "qrPage",
                          arguments: {"name": _linkedInId});
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(fontSize: 16),
                    ))
              ],
            )),
      ),
    );
  }
}
