import 'package:csc_picker/csc_picker.dart';
import 'package:durood_together_app/AppReserved/constants.dart';
import 'package:durood_together_app/Models/location.dart';
import 'package:durood_together_app/Models/user_profile.dart';
import 'package:durood_together_app/Services/Firebase/firestore_service_for_settings.dart';
import 'package:durood_together_app/Services/dialogs.dart';
import 'package:durood_together_app/Services/location_finder.dart';
import 'package:durood_together_app/Widgets/app_elevated_button.dart';
import 'package:durood_together_app/Widgets/app_text_field.dart';
import 'package:durood_together_app/Widgets/my_scaffold.dart';
import 'package:flutter/material.dart';

class UserProfileEditing extends StatefulWidget {
  const UserProfileEditing({Key? key}) : super(key: key);

  @override
  _UserProfileEditingState createState() => _UserProfileEditingState();
}

class _UserProfileEditingState extends State<UserProfileEditing> {
  String? city;
  String? country;
  String? state;
  String? name;
  TextEditingController nameController = TextEditingController();
  FocusNode nameNode = FocusNode();
  bool manualLocation = false;
  bool editName = false;

  FireStoreServiceForSettings myService = FireStoreServiceForSettings();

  @override
  Widget build(BuildContext context) {
    nameController.text = name ?? "";
    nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: nameController.text.length));
    return GestureDetector(
      onTap: () {
        setState(() {
          name = nameController.text;
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        });
      },
      child: MyScaffold(
        head1: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: buildTopRow(context),
        ),
        body: Expanded(
          child: buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            editName
                ? buildNameField()
                : StreamBuilder<UserProfile>(
                    stream: myService.getUserData(),
                    builder: (BuildContext context,
                        AsyncSnapshot<UserProfile> snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return AppTextField(
                          controller: TextEditingController(),
                          focusNode: FocusNode(),
                          hintText: snapshot.data?.name == "" ? "No Name" : snapshot.data?.name ?? "No Name",
                          formatter: const [],
                          enabled: false,
                        );
                      } else {
                        return AppTextField(
                          controller: TextEditingController(),
                          focusNode: FocusNode(),
                          hintText: "Name",
                          formatter: const [],
                          enabled: false,
                        );
                      }
                    },
                  ),
            Center(
              child: Tooltip(
                message: editName ? "Cancel" : "Edit",
                child: AppElevatedButton(
                  buttonText: editName ? "Cancel" : "Edit",
                  icon: editName ? Icons.not_interested : Icons.edit,
                  onPressed: () {
                    setState(() {
                      editName = !editName;
                    });
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Current Location",
                style: TextStyle(
                  color: Constants.appHighlightColor,
                ),
              ),
            ),
            buildLocationDetails(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Change Location",
                style: TextStyle(
                  color: Constants.appHighlightColor,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      AppElevatedButton(
                        onPressed: () {
                          setState(() {
                            manualLocation = !manualLocation;
                          });
                        },
                        textSize: Constants.appHeading5Size,
                        buttonText: "Manual Locate",
                      ),
                      AppElevatedButton(
                        onPressed: () {
                          setState(() {
                            getDialog(
                              context: context,
                              title: Text(
                                'Get location Automatically?',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                              content: Text(
                                'Your location will be accessed',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                              closeText: 'Dismiss',
                              okText: 'Yes',
                              okOnPressed: () async {
                                AppLocation result = AppLocation();
                                Navigator.pop(context);
                                getWaitingDialog(context: context);
                                try {
                                  result = await getAddressFromLatLng();
                                } catch (e) {
                                  // print(e.toString());
                                } finally {
                                  Navigator.pop(context);
                                  if (result.error == null) {
                                    country = result.country;
                                    city = result.city;
                                  }
                                  getDialog(
                                      context: context,
                                      title: Text(
                                        result.message ?? "",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                        ),
                                      ),
                                      content: result.error == null
                                          ? Text(
                                              "${result.city}, ${result.country}",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                              ),
                                            )
                                          : Text(
                                              "${result.error}",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                              ),
                                            ),
                                      closeText: 'Dismiss',
                                      okText: "Save",
                                      okOnPressed: () async {
                                        Navigator.pop(context);
                                        getWaitingDialog(context: context);
                                        try {
                                          await saveUserLocation();
                                        } finally {
                                          Navigator.pop(context);
                                        }
                                      });
                                }
                              },
                            );
                          });
                        },
                        textSize: Constants.appHeading5Size,
                        buttonText: "Auto Locate",
                      ),
                      Visibility(
                        visible: manualLocation,
                        child: AppElevatedButton(
                          buttonColor: Constants.appRedColor,
                          textColor: Constants.appPrimaryColor,
                          onPressed: () {
                            setState(() {
                              manualLocation = !manualLocation;
                            });
                          },
                          textSize: Constants.appHeading5Size,
                          buttonText: "Cancel",
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            buildManualDataPicker(),
            buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget buildSaveButton() {
    return manualLocation
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppElevatedButton(
                onPressed: () async {
                  getWaitingDialog(context: context);
                  try {
                    await saveUserLocation();
                  } finally {
                    Navigator.pop(context);
                  }
                  setState(() {
                    nameNode.unfocus();
                    name = nameController.text;
                    manualLocation = false;
                  });
                  // Navigator.pop(context);
                },
                textSize: Constants.appHeading5Size,
                buttonText: "Save Location",
              ),
            ),
          )
        : Container();
  }

  Widget buildManualDataPicker() {
    return Visibility(
      visible: manualLocation,
      child: CSCPicker(
        disableCountry: false,

        ///Enable disable state dropdown [OPTIONAL PARAMETER]
        showStates: true,

        /// Enable disable city drop down [OPTIONAL PARAMETER]
        showCities: true,

        ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
        // flagState: CountryFlag.DISABLE,
        ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
        dropdownDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
          color: Constants.appPrimaryColor,
          border: Border.all(
            color: Constants.appPrimaryColor,
            width: 10,
          ),
        ),
        layout: Layout.vertical,

        ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
        disabledDropdownDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
          color: Colors.grey.shade300,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 10,
          ),
        ),

        ///placeholders for dropdown search field
        countrySearchPlaceholder: "Country",
        stateSearchPlaceholder: "State",
        citySearchPlaceholder: "City",

        ///labels for dropdown
        countryDropdownLabel: "Country",
        stateDropdownLabel: "State",
        cityDropdownLabel: "City",

        ///selected item style [OPTIONAL PARAMETER]
        selectedItemStyle: const TextStyle(
          color: Constants.appPrimaryDarkColor,
          fontSize: 14,
        ),
        //DropdownDialog Heading style [OPTIONAL PARAMETER]
        dropdownHeadingStyle: const TextStyle(
          color: Constants.appPrimaryDarkColor,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),

        ///DropdownDialog Item style [OPTIONAL PARAMETER]
        dropdownItemStyle: const TextStyle(
          color: Constants.appPrimaryDarkColor,
          fontSize: 14,
        ),

        ///Dialog box radius [OPTIONAL PARAMETER]
        dropdownDialogRadius: 10.0,

        ///Search bar radius [OPTIONAL PARAMETER]
        searchBarRadius: 10.0,

        ///triggers once country selected in dropdown
        onCountryChanged: (value) {
          setState(() {
            ///store value in country variable
            var re = RegExp(r' +');
            country = value.trim().split(re).sublist(1).join(' ');
          });
        },

        ///triggers once state selected in dropdown
        onStateChanged: (value) {
          setState(() {
            state = value;
          });
        },

        ///triggers once city selected in dropdown
        onCityChanged: (value) {
          setState(() {
            ///store value in city variable
            city = value?.trim();
          });
        },
      ),
    );
  }

  Widget buildNameField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AppTextField(
        controller: nameController,
        focusNode: nameNode,
        hintText: "Enter new Name",
        formatter: const [],
        onSubmitted: (value) {
          setState(() {
            name = nameController.text;
          });
        },
        suffix: AppElevatedButton(
          buttonText: "Save",
          icon: Icons.save,
          onPressed: () async {
            getWaitingDialog(context: context);
            try {
              await myService.saveName(nameController.text);
              nameController.text = '';
              setState(() {
                editName = !editName;
              });
            } finally {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  Widget buildLocationDetails() {
    return Column(
      children: [
        StreamBuilder<UserProfile>(
            stream: myService.getUserData(),
            builder:
                (BuildContext context, AsyncSnapshot<UserProfile> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppTextField(
                      controller: TextEditingController(),
                      focusNode: FocusNode(),
                      hintText: snapshot.data?.country == "" ? "No country Set" : snapshot.data?.country ?? "Country",
                      formatter: const [],
                      enabled: false),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppTextField(
                      controller: TextEditingController(),
                      focusNode: FocusNode(),
                      hintText: "Country",
                      formatter: const [],
                      enabled: false),
                );
              }
            }),
        StreamBuilder<UserProfile>(
            stream: myService.getUserData(),
            builder:
                (BuildContext context, AsyncSnapshot<UserProfile> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppTextField(
                      controller: TextEditingController(),
                      focusNode: FocusNode(),
                      hintText: snapshot.data?.city == "" ? "No city Set" : snapshot.data?.city ?? "City",
                      formatter: const [],
                      enabled: false),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppTextField(
                      controller: TextEditingController(),
                      focusNode: FocusNode(),
                      hintText: "City",
                      formatter: const [],
                      enabled: false),
                );
              }
            }),
      ],
    );
  }

  Widget buildTopRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "User profile",
              style: TextStyle(
                  color: Constants.appHighlightColor,
                  fontSize: Constants.appHeading5Size),
            ),
          ),
          InkWell(
            onTap: () {
              getDialog(
                title: Text(
                  'Go back?',
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                content: Text(
                  'Any unsaved changes will be discarded',
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                context: context,
                closeText: 'Dismiss',
                okText: 'Yes',
                okOnPressed: () {
                  Navigator.pop(context); //close Dialog
                  Navigator.pop(context); //close Profile Page
                },
              );
            },
            splashColor: Constants.appHighlightColor,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }

  Future saveUserLocation() async {
    await myService.saveLocation(country ?? "", city ?? "");
  }
}
