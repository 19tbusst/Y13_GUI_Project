import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:y13_gui_project/main.dart';
import 'home_page.dart';

class ItemCard extends StatefulWidget {
  ItemCard({super.key, required this.item});

  final Item item;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  String _name = '';
  bool _isIssued = false;
  DateTime _date = DateTime.now();
  String _image = '';
  String _borrowerName = '';
  String _borrowerEmail = '';
  String _id = '';

  GlobalKey issueKey = GlobalKey<FormState>();
  GlobalKey returnKey = GlobalKey<FormState>();

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
    });
  }

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
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
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
                      TextButton(
                          onPressed: () async {
                            if ((issueKey.currentState! as FormState)
                                .validate()) {
                              (issueKey.currentState! as FormState).save();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Item Issued')),
                              );

                              setState(() {
                                _isIssued = true;
                              });

                              Navigator.of(context).pop();

                              await write();
                            } else {}
                          },
                          child: const Text('Submit')),
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

  Future<void> showReturnPopup(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Return Item'),
              content: Form(
                key: returnKey,
                child: SizedBox(
                  height: 298,
                  child: Column(
                    children: <Widget>[
                      Placeholder(),
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
  void initState() {
    super.initState();
    _name = widget.item.name;
    _isIssued = widget.item.isIssued;
    _date = widget.item.date;
    _image = widget.item.image;
    _borrowerName = widget.item.borrowerName;
    _borrowerEmail = widget.item.borrowerEmail;
    _id = widget.item.id;
  }

  @override
  Widget build(BuildContext context) {
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
                            (MediaQuery.of(context).size.width <= 500)
                                ? IconButton(
                                    icon: _isIssued
                                        ? const FaIcon(
                                            FontAwesomeIcons.solidSquarePlus)
                                        : const FaIcon(
                                            FontAwesomeIcons.solidSquareMinus),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    iconSize: 30,
                                    onPressed: () {
                                      if (_isIssued) {
                                        showReturnPopup(context);
                                      } else {
                                        showIssuePopup(context);
                                      }
                                    },
                                  )
                                : ElevatedButton(
                                    child: Text(_isIssued ? 'Issue' : 'Return'),
                                    onPressed: () {
                                      if (_isIssued) {
                                        showReturnPopup(context);
                                      } else {
                                        showIssuePopup(context);
                                      }
                                    },
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
                        Text('${_date.day}/${_date.month}/${_date.year}'),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 200,
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
