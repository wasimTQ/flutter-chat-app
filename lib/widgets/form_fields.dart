import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final passwordController = TextEditingController();

  Function onChanged;
  String label, error_text;
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
  PasswordField({this.onChanged, this.error_text, this.label});
}

class _PasswordFieldState extends State<PasswordField> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordController,
      onChanged: widget.onChanged,
      obscureText: hidePassword,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(Icons.remove_red_eye),
          splashRadius: 15.0,
          color: hidePassword ? Colors.lightBlue[300] : Colors.grey[500],
          onPressed: () {
            setState(() {
              hidePassword = !hidePassword;
            });
          },
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
        labelText: widget.label,
        errorText: widget.error_text,
      ),
    );
  }
}

class InputField extends StatelessWidget {
  String label;
  Function onChanged;
  final inputController = TextEditingController();

  InputField({this.label, @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: inputController,
      onChanged: onChanged,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
        labelText: label,
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  String label;
  Color color;
  Function onPressed;

  ActionButton({this.label, this.color, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.5),
      child: Text(
        label,
        style: TextStyle(fontSize: 21),
      ),
      minWidth: 250.0,
      color: color,
      colorBrightness: Brightness.dark,
      splashColor: Colors.black12,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: color)),
    );
  }
}
