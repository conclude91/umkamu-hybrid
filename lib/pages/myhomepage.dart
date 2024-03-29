import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:umkamu/models/data.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  static const String id = "myhomepage";

  @override
  MyHomePageState createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  var data;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormFieldState> _specifyTextFieldKey =
  GlobalKey<FormFieldState>();

  ValueChanged _onChanged = (val) => print(val);
  var genderOptions = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FormBuilder Example'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            FormBuilder(
              // context,
              key: _fbKey,
              // autovalidate: true,
              initialValue: {
                'movie_rating': 3,
              },
              readOnly: false,
              child: Column(
                children: <Widget>[
                  FormBuilderFilterChip(
                    attribute: 'filter_chip',
                    decoration: InputDecoration(
                      labelText: 'Select many options',
                    ),
                    options: [
                      FormBuilderFieldOption(
                          value: 'Test', child: Text('Test')),
                      FormBuilderFieldOption(
                          value: 'Test 1', child: Text('Test 1')),
                      FormBuilderFieldOption(
                          value: 'Test 2', child: Text('Test 2')),
                      FormBuilderFieldOption(
                          value: 'Test 3', child: Text('Test 3')),
                      FormBuilderFieldOption(
                          value: 'Test 4', child: Text('Test 4')),
                    ],
                  ),
                  SizedBox(height: 15),
                  FormBuilderChoiceChip(
                    attribute: 'choice_chip',
                    decoration: InputDecoration(
                      labelText: 'Select an option',
                    ),
                    options: [
                      FormBuilderFieldOption(
                          value: 'Test', child: Text('Test')),
                      FormBuilderFieldOption(
                          value: 'Test 1', child: Text('Test 1')),
                      FormBuilderFieldOption(
                          value: 'Test 2', child: Text('Test 2')),
                      FormBuilderFieldOption(
                          value: 'Test 3', child: Text('Test 3')),
                      FormBuilderFieldOption(
                          value: 'Test 4', child: Text('Test 4')),
                    ],
                  ),
                  SizedBox(height: 15),
                  SizedBox(height: 15),
                  FormBuilderColorPicker(
                    attribute: 'color_picker',
                    // initialValue: Colors.yellow,
                    colorPickerType: ColorPickerType.SlidePicker,
                    decoration: InputDecoration(labelText: 'Pick Color'),
                  ),
                  SizedBox(height: 15),
                  FormBuilderChipsInput(
                    decoration: InputDecoration(labelText: 'Chips'),
                    attribute: 'chips_test',
                    onChanged: _onChanged,
                    initialValue: [
                      Contact('Andrew', 'stock@man.com',
                          'https://d2gg9evh47fn9z.cloudfront.net/800px_COLOURBOX4057996.jpg'),
                    ],
                    maxChips: 5,
                    findSuggestions: (String query) {
                      if (query.isNotEmpty) {
                        var lowercaseQuery = query.toLowerCase();
                        return contacts.where((profile) {
                          return profile.name
                              .toLowerCase()
                              .contains(query.toLowerCase()) ||
                              profile.email
                                  .toLowerCase()
                                  .contains(query.toLowerCase());
                        }).toList(growable: false)
                          ..sort((a, b) => a.name
                              .toLowerCase()
                              .indexOf(lowercaseQuery)
                              .compareTo(b.name
                              .toLowerCase()
                              .indexOf(lowercaseQuery)));
                      } else {
                        return const <Contact>[];
                      }
                    },
                    chipBuilder: (context, state, profile) {
                      return InputChip(
                        key: ObjectKey(profile),
                        label: Text(profile.name),
                        avatar: CircleAvatar(
                          backgroundImage: NetworkImage(profile.imageUrl),
                        ),
                        onDeleted: () => state.deleteChip(profile),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    },
                    suggestionBuilder: (context, state, profile) {
                      return ListTile(
                        key: ObjectKey(profile),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(profile.imageUrl),
                        ),
                        title: Text(profile.name),
                        subtitle: Text(profile.email),
                        onTap: () => state.selectSuggestion(profile),
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  FormBuilderDateTimePicker(
                    attribute: 'date',
                    onChanged: _onChanged,
                    inputType: InputType.time,
                    decoration: InputDecoration(
                      labelText: 'Appointment Time',
                    ),
                    validator: (val) => null,
                    initialTime: TimeOfDay(hour: 8, minute: 0),
                    // initialValue: DateTime.now(),
                    // readonly: true,
                  ),
                  SizedBox(height: 15),
                  FormBuilderDateRangePicker(
                    attribute: 'date_range',
                    firstDate: DateTime(1970),
                    lastDate: DateTime.now(),
                    initialValue: [DateTime.now().subtract(Duration(days: 30)), DateTime.now().subtract(Duration(seconds: 10))],
                    format: DateFormat('yyyy-MM-dd'),
                    onChanged: _onChanged,
                    decoration: InputDecoration(
                      labelText: 'Date Range',
                      helperText: 'Helper text',
                      hintText: 'Hint text',
                    ),
                  ),
                  SizedBox(height: 15),
                  FormBuilderSlider(
                    attribute: 'slider',
                    validators: [FormBuilderValidators.min(6)],
                    onChanged: _onChanged,
                    min: 0.0,
                    max: 10.0,
                    initialValue: 7.0,
                    divisions: 20,
                    activeColor: Colors.red,
                    inactiveColor: Colors.pink[100],
                    decoration: InputDecoration(
                      labelText: 'Number of things',
                    ),
                  ),
                  SizedBox(height: 15),
                  FormBuilderRangeSlider(
                    attribute: 'range_slider',
                    validators: [FormBuilderValidators.min(6)],
                    onChanged: _onChanged,
                    min: 0.0,
                    max: 100.0,
                    initialValue: RangeValues(4, 7),
                    divisions: 20,
                    activeColor: Colors.red,
                    inactiveColor: Colors.pink[100],
                    decoration: InputDecoration(
                      labelText: 'Price Range',
                    ),
                  ),
                  SizedBox(height: 15),
                  FormBuilderCheckbox(
                    attribute: 'accept_terms',
                    initialValue: false,
                    onChanged: _onChanged,
                    leadingInput: true,
                    label: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'I have read and agree to the ',
                          ),
                          TextSpan(
                            text: 'Terms and Conditions',
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('launch url');
                              },
                          ),
                        ],
                      ),
                    ),
                    validators: [
                      FormBuilderValidators.requiredTrue(
                        errorText:
                        'You must accept terms and conditions to continue',
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    'This value is passed along to the [Text.maxLines] attribute of the [Text] widget used to display the hint text.',
                    style: Theme.of(context).inputDecorationTheme.labelStyle,
                  ),
                  FormBuilderTextField(
                    attribute: 'age',
                    decoration: InputDecoration(
                      labelText:
                      'This value is passed along to the [Text.maxLines] attribute of the [Text] widget used to display the hint text.',
                    ),
                    onChanged: _onChanged,
                    valueTransformer: (text) {
                      return text == null ? null : num.tryParse(text);
                    },
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                      // FormBuilderValidators.max(70),
                      FormBuilderValidators.minLength(2, allowEmpty: true),
                    ],
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 15),
                  FormBuilderDropdown(
                    attribute: 'gender',
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                          width: 20,
                        ),
                      ),
                    ),
                    // initialValue: 'Male',
                    hint: Text('Select Gender'),
                    validators: [FormBuilderValidators.required()],
                    items: genderOptions
                        .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text('$gender'),
                    ))
                        .toList(),
                  ),
                  SizedBox(height: 15),
                  FormBuilderTypeAhead(
                    decoration: InputDecoration(
                      labelText: 'Country',
                    ),
                    attribute: 'country',
                    onChanged: _onChanged,
                    itemBuilder: (context, country) {
                      return ListTile(
                        title: Text(country),
                      );
                    },
                    controller: TextEditingController(text: ''),
                    initialValue: 'Uganda',
                    suggestionsCallback: (query) {
                      if (query.isNotEmpty) {
                        var lowercaseQuery = query.toLowerCase();
                        return allCountries.where((country) {
                          return country.toLowerCase().contains(lowercaseQuery);
                        }).toList(growable: false)
                          ..sort((a, b) => a
                              .toLowerCase()
                              .indexOf(lowercaseQuery)
                              .compareTo(
                              b.toLowerCase().indexOf(lowercaseQuery)));
                      } else {
                        return allCountries;
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  FormBuilderTypeAhead<Contact>(
                    decoration: InputDecoration(
                      labelText: 'Contact Person',
                    ),
                    initialValue: contacts[0],
                    attribute: 'contact_person',
                    onChanged: _onChanged,
                    itemBuilder: (context, Contact contact) {
                      return ListTile(
                        title: Text(contact.name),
                        subtitle: Text(contact.email),
                      );
                    },
                    selectionToTextTransformer: (Contact c) => c.email,
                    suggestionsCallback: (query) {
                      if (query.isNotEmpty) {
                        var lowercaseQuery = query.toLowerCase();
                        return contacts.where((contact) {
                          return contact.name
                              .toLowerCase()
                              .contains(lowercaseQuery);
                        }).toList(growable: false)
                          ..sort((a, b) => a.name
                              .toLowerCase()
                              .indexOf(lowercaseQuery)
                              .compareTo(b.name
                              .toLowerCase()
                              .indexOf(lowercaseQuery)));
                      } else {
                        return contacts;
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  FormBuilderRadio(
                    decoration:
                    InputDecoration(labelText: 'My chosen language'),
                    attribute: 'best_language',
                    leadingInput: true,
                    onChanged: _onChanged,
                    validators: [FormBuilderValidators.required()],
                    options: ['Dart', 'Kotlin', 'Java', 'Swift', 'Objective-C']
                        .map((lang) => FormBuilderFieldOption(
                      value: lang,
                      child: Text('$lang'),
                    ))
                        .toList(growable: false),
                  ),
                  SizedBox(height: 15),
                  /*FormBuilderRadioGroup(
                    decoration: InputDecoration(labelText: 'Pick a number'),
                    attribute: 'number',
                    readOnly: true,
                    options: [
                      FormBuilderFieldOption(
                        value: 1,
                        child: Text('One'),
                      ),
                      FormBuilderFieldOption(
                        value: 2,
                        child: Text('Two'),
                      ),
                      FormBuilderFieldOption(
                        value: 3,
                        child: Text('Three'),
                      ),
                    ],
                  ),*/
                  SizedBox(height: 15),
                  FormBuilderSegmentedControl(
                    decoration:
                    InputDecoration(labelText: 'Movie Rating (Archer)'),
                    attribute: 'movie_rating',
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    options: List.generate(5, (i) => i + 1)
                        .map((number) => FormBuilderFieldOption(
                      value: number,
                      child: Text(
                        '$number',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
                        .toList(),
                    onChanged: _onChanged,
                  ),
                  SizedBox(height: 15),
                  FormBuilderSwitch(
                    label: Text('I Accept the tems and conditions'),
                    attribute: 'accept_terms_switch',
                    initialValue: true,
                    onChanged: _onChanged,
                  ),
                  SizedBox(height: 15),
                  FormBuilderTouchSpin(
                    decoration: InputDecoration(labelText: 'Stepper'),
                    attribute: 'stepper',
                    initialValue: 10,
                    step: 1,
                    iconSize: 48.0,
                    addIcon: Icon(Icons.arrow_right),
                    subtractIcon: Icon(Icons.arrow_left),
                  ),
                  SizedBox(height: 15),
                  FormBuilderRate(
                    decoration: InputDecoration(labelText: 'Rate this form'),
                    attribute: 'rate',
                    iconSize: 32.0,
                    initialValue: 1.0,
                    max: 5.0,
                    onChanged: _onChanged,
                    // readOnly: true,
                    filledColor: Colors.red,
                    emptyColor: Colors.pink[100],
                    isHalfAllowed: true,
                  ),
                  SizedBox(height: 15),
                  FormBuilderCheckboxList(
                    decoration:
                    InputDecoration(labelText: 'The language of my people'),
                    attribute: 'languages',
                    initialValue: ['Dart'],
                    leadingInput: true,
                    options: [
                      FormBuilderFieldOption(value: 'Dart'),
                      FormBuilderFieldOption(value: 'Kotlin'),
                      FormBuilderFieldOption(value: 'Java'),
                      FormBuilderFieldOption(value: 'Swift'),
                      FormBuilderFieldOption(value: 'Objective-C'),
                    ],
                    onChanged: _onChanged,
                  ),
                  SizedBox(height: 15),
                  FormBuilderImagePicker(
                    attribute: 'images',
                    decoration: InputDecoration(
                      labelText: 'Images',
                    ),
                    maxImages: 3,
                    iconColor: Colors.red,
                    // readOnly: true,
                    validators: [
                      FormBuilderValidators.required(),
                          (images) {
                        if (images.length < 2) {
                          return 'Two or more images required.';
                        }
                        return null;
                      }
                    ],
                  ),
                  SizedBox(height: 15),
                  FormBuilderCountryPicker(
                    initialValue: 'Germany',
                    attribute: 'country',
                    cursorColor: Colors.black,
                    // style: TextStyle(color: Colors.black, fontSize: 18),
                    priorityListByIsoCode: ['US'],
                    valueTransformer: (value) {
                      return value.isoCode;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Country'),
                    validators: [
                      FormBuilderValidators.required(
                          errorText: 'This field required.'),
                    ],
                  ),
                  SizedBox(height: 15),
                  FormBuilderPhoneField(
                    attribute: 'phone_number',
                    initialValue: '+254',
                    // defaultSelectedCountryIsoCode: 'KE',
                    cursorColor: Colors.black,
                    // style: TextStyle(color: Colors.black, fontSize: 18),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone Number',
                    ),
                    onChanged: _onChanged,
                    priorityListByIsoCode: ['US'],
                    validators: [
                      FormBuilderValidators.numeric(
                          errorText: 'Invalid phone number'),
                      FormBuilderValidators.required(
                          errorText: 'This field reqired')
                    ],
                  ),
                  SizedBox(height: 15),
                  FormBuilderSignaturePad(
                    decoration: InputDecoration(labelText: 'Signature'),
                    attribute: 'signature',
                    // height: 250,
                    clearButtonText: 'Start Over',
                    onChanged: _onChanged,
                  ),
                  SizedBox(height: 15),
                  FormBuilderRadioGroup(
                    attribute: 'radio_group',
                    decoration: InputDecoration(labelText: 'Radio Group'),
                    onChanged: _onChanged,
                    options: [
                      FormBuilderFieldOption(value: 'Male',),
                      FormBuilderFieldOption(value: 'Female',),
                    ],
                  ),
                  SizedBox(height: 15),
                  FormBuilderCustomField(
                    attribute: 'name',
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                    initialValue: 'Argentina',
                    formField: FormField(
                      enabled: true,
                      builder: (FormFieldState<dynamic> field) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'FormBuilderCustomField',
                            contentPadding:
                            EdgeInsets.only(top: 10.0, bottom: 0.0),
                            border: InputBorder.none,
                            errorText: field.errorText,
                          ),
                          child: Container(
                            height: 200,
                            child: CupertinoPicker(
                              itemExtent: 30,
                              children:
                              allCountries.map((c) => Text(c)).toList(),
                              onSelectedItemChanged: (index) {
                                print(index);
                                field.didChange(allCountries[index]);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    color: Theme.of(context).accentColor,
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_fbKey.currentState.saveAndValidate()) {
                        print(_fbKey
                            .currentState.value['contact_person'].runtimeType);
                        print(_fbKey.currentState.value);
                      } else {
                        print(_fbKey
                            .currentState.value['contact_person'].runtimeType);
                        print(_fbKey.currentState.value);
                        print('validation failed');
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: MaterialButton(
                    color: Theme.of(context).accentColor,
                    child: Text(
                      'Reset',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _fbKey.currentState.reset();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}