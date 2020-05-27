import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:DirectMF/ui/common/text.dart';

class ClearableTextInput extends StatefulWidget {
  final Function(String) onChange;
  final String value;
  final String hintText;
  final TextStyle style;
  final TextInputType keyboardType;
  final int maxLines;
  final EdgeInsetsGeometry contentPadding;
  final InputBorder border;
  final bool obscureText;
  final String labelText;
  final TextEditingController textCtrl;

  ClearableTextInput(
      {@required this.onChange,
      @required this.hintText,
      this.value,
      this.style,
      this.keyboardType,
      this.maxLines,
      this.contentPadding,
      this.border,
      this.obscureText,
      this.labelText,
      this.textCtrl});

  @override
  State<StatefulWidget> createState() => _TextInputState(value);
}

class _TextInputState extends State<ClearableTextInput> {
  final _focus = new FocusNode();
  final _controller;

  bool clearable = false;
  bool focused = false;

  _TextInputState(value)
      : _controller = isBlank(value)
            ? TextEditingController()
            : TextEditingController.fromValue(TextEditingValue(text: value));

  @override
  void initState() {
    _controller.addListener(() => isClearable());
    _controller.addListener(() => widget.onChange(_controller.text));
    _focus.addListener(() => focused = !focused);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void isClearable() {
    setState(() {
      clearable = !isBlank(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textCtrl ?? _controller,
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.sentences,
      obscureText: widget.obscureText ?? false,
      style: widget.style,
      keyboardType: widget.keyboardType ??
          (widget.maxLines == 1 ? TextInputType.text : TextInputType.multiline),
      maxLines: widget.maxLines ?? 1,
      focusNode: _focus,
      decoration: InputDecoration(
        contentPadding: widget.contentPadding,
        hintText: widget.hintText,
        labelText: (widget.labelText) ?? '',
        border: widget.border ?? OutlineInputBorder(),
        isDense: true,
        suffixIcon: focused
            ? IconButton(
                icon: Icon(Icons.clear),
                disabledColor: Colors.transparent,
                // TODO: breaks when clearing text input. Below is workaround.
                //  For more information, see:
                //  https://github.com/flutter/flutter/pull/38722
                //  https://github.com/flutter/flutter/issues/36324
                //  https://github.com/flutter/flutter/issues/17647
                //  https://github.com/go-flutter-desktop/go-flutter/issues/221
                onPressed: clearable
                    ? () => WidgetsBinding.instance
                        .addPostFrameCallback((_) => _controller.clear())
                    : null,
              )
            : null,
      ),
    );
  }
}

class EmailFormField extends StatefulWidget {
  final regEx = RegExp(EmailFormField.pattern);
  static const pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  final Function(String) onSaved;
  final bool showHelpText;

  EmailFormField({Key key, @required this.onSaved, showHelpText})
      : this.showHelpText = showHelpText ?? true,
        super(key: key);

  @override
  _EmailFormFieldState createState() => _EmailFormFieldState();
}

class _EmailFormFieldState extends State<EmailFormField> {
  final _controller = TextEditingController();

  bool touched = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormTitleText(text: "Email"),
          if (widget.showHelpText)
            Text(
              "The address should be of a form email@provider.domain. "
              "For example: email@example.com",
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 14),
            ),
          TextFormField(
            controller: _controller,
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            validator: (value) => _validateEmail(value),
            onChanged: (String value) => setState(() {
              this.touched = isNotEmpty(value);
            }),
            onSaved: (value) => widget.onSaved(value),
            decoration: touched
                ? InputDecoration(
                    suffixIcon: InkWell(
                      child: Icon(Icons.clear, color: Colors.grey),
                      onTap: () => _clearInput(),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  void _clearInput() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.clear());
    setState(() {
      touched = false;
    });
  }

  String _validateEmail(String email) {
    email = email.trim();
    if (email.length == 0) {
      return "Email field cannot be empty";
    } else if (!widget.regEx.hasMatch(email)) {
      return "Invalid email: use 'email@provider.domain' form";
    } else {
      return null;
    }
  }
}

class PasswordFormField extends StatefulWidget {
  final Function(String) onSaved;
  final bool showHelpText;

  PasswordFormField({Key key, @required this.onSaved, showHelpText})
      : this.showHelpText = showHelpText ?? true,
        super(key: key);

  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool hideText = true;
  bool touched = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormTitleText(text: "Password", padding: EdgeInsets.only(top: 8.0)),
          if (widget.showHelpText)
            Text(
              "Make sure to use a strong password: use lowercase and capital "
              "letters, special symbols, numbers.",
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 14),
            ),
          TextFormField(
            key: widget.key,
            maxLines: 1,
            obscureText: hideText,
            autofocus: false,
            onChanged: (String value) => setState(() {
              this.touched = isNotEmpty(value);
            }),
            validator: (value) => _validatePassword(value),
            onSaved: (value) => widget.onSaved(value),
            decoration: touched
                ? InputDecoration(
                    suffixIcon: InkWell(
                      child: Icon(
                        Icons.remove_red_eye,
                        color: hideText ? Colors.grey : Colors.blue,
                      ),
                      onTap: () => setState(() {
                        this.hideText = !hideText;
                      }),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  String _validatePassword(String password) {
    if (password.isEmpty) {
      return "Password field cannot be empty";
    } else if (password.length < 6) {
      return "Password should contain at least 6 symbols";
    }
    return null;
  }
}
