// Flutter packages
import 'package:flutter/material.dart';

// Pub packages
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

// Local files
import 'package:y13_gui_project/main.dart';

class ItemCard extends StatefulWidget {
  ItemCard({super.key, required this.item});

  final Item item;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  // Card properties
  String _name = '';
  bool _isIssued = false;
  DateTime _date = DateTime.now();
  String _image = '';
  String _borrowerName = '';
  String _borrowerEmail = '';
  String _id = '';
  DateTime _dueDate = DateTime.now();

  // Popup properties
  bool _isConfirmed = false;

  // Form key
  GlobalKey issueKey = GlobalKey<FormState>();

  // writes the item to the database
  Future write() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("items/");

    await ref.child(_id).set({
      'name': _name,
      'isIssued': _isIssued,
      'date': _date.toString(),
      'image': _image,
      'id': _id,
      'borrowerName': _borrowerName,
      'borrowerEmail': _borrowerEmail,
      'dueDate': _dueDate.toString(),
    });
  }

  // issue popup
  Future<void> showIssuePopup(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Issue Item'),
              content: Form(
                key: issueKey,
                child: SizedBox(
                  height: 298,
                  child: Column(
                    children: <Widget>[
                      // Borrower name
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Borrower name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            _borrowerName = value!;
                          });
                        },
                      ),
                      // Borrower email
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        // checks if the email is valid
                        validator: (value) {
                          // regex from https://regexr.com/3e48o
                          RegExp regex =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          bool isPass = regex.hasMatch(value!);

                          if (!isPass) {
                            return 'Please enter an email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            _borrowerEmail = value!;
                          });
                        },
                      ),
                      const Spacer(),
                      // submit button
                      TextButton(
                          onPressed: () async {
                            // checks if the form is valid
                            if ((issueKey.currentState! as FormState)
                                .validate()) {
                              (issueKey.currentState! as FormState).save();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Item Issued')),
                              );

                              // sets the due date to 7 days from now
                              setState(() {
                                _dueDate = DateTime.now().add(
                                  const Duration(days: 7),
                                );

                                _isIssued = true;
                              });

                              Navigator.of(context).pop();

                              await write();
                            } else {}
                          },
                          child: const Text(
                            'Issue',
                            style: TextStyle(fontSize: 17),
                          )),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // return popup
  Future<void> showReturnPopup(BuildContext context) async {
    _isConfirmed = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Return Item'),
              content: Form(
                child: SizedBox(
                  height: 298,
                  child: Column(
                    children: <Widget>[
                      // confirm return checkbox
                      CheckboxListTile(
                        title: const Text('Confirm Return'),
                        value: _isConfirmed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // update checkbox value
                        onChanged: (bool? value) {
                          setState(() {
                            _isConfirmed = value!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.trailing,
                      ),
                      const Spacer(),
                      // submit form
                      TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all<Color>(
                            _isConfirmed
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha(20)
                                : Colors.transparent,
                          ),
                        ),
                        // submit form if checkbox is checked
                        onPressed: () async {
                          if (_isConfirmed) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Item Returned')),
                            );

                            // reset item properties
                            setState(() {
                              _isIssued = false;
                              _borrowerName = '';
                              _borrowerEmail = '';
                            });

                            Navigator.of(context).pop();

                            await write();
                          } else {}
                        },
                        child: Text(
                          'Return',
                          style: TextStyle(
                              color: _isConfirmed
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                              fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // item properties
    _name = widget.item.name;
    _isIssued = widget.item.isIssued;
    _date = widget.item.date;
    _image = widget.item.image;
    _borrowerName = widget.item.borrowerName;
    _borrowerEmail = widget.item.borrowerEmail;
    _id = widget.item.id;

    // return date
    return Card(
      elevation: 2.5,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 200, maxHeight: 200),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 224,
                  maxHeight: 200),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          _name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            // swaps the icon depending on the screen size
                            (MediaQuery.of(context).size.width <= 500)
                                ? IconButton(
                                    // swaps the icon depending on the item status
                                    icon: _isIssued
                                        ? const FaIcon(
                                            FontAwesomeIcons.solidSquarePlus)
                                        : const FaIcon(
                                            FontAwesomeIcons.solidSquareMinus),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    iconSize: 28,
                                    onPressed: () {
                                      if (_isIssued) {
                                        showReturnPopup(context);
                                      } else {
                                        showIssuePopup(context);
                                      }
                                    },
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child:
                                          // swaps the text depending on the item status
                                          Text(_isIssued ? 'Return' : 'Issue'),
                                      onPressed: () {
                                        if (_isIssued) {
                                          showReturnPopup(context);
                                        } else {
                                          showIssuePopup(context);
                                        }
                                      },
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    _isIssued
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Borrower: $_borrowerName')
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: Text('Email: $_borrowerEmail'),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      // converts the due date to a string
                                      child: Text('Due: ${_dueDate.day}/'
                                          '${_dueDate.month}/${_dueDate.year}'),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Card(
                          color: Theme.of(context).colorScheme.background,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(_isIssued ? 'Issued' : 'Not Issued'),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        // converts the date to a string
                        Text('${_date.day}/${_date.month}/${_date.year}'),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // item image display
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 200,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(_image),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
