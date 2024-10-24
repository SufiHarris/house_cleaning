// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Assigned Tasks`
  String get assigned {
    return Intl.message(
      'Assigned Tasks',
      name: 'assigned',
      desc: '',
      args: [],
    );
  }

  /// `No tasks available`
  String get noTasks {
    return Intl.message(
      'No tasks available',
      name: 'noTasks',
      desc: '',
      args: [],
    );
  }

  /// `Years`
  String get years {
    return Intl.message(
      'Years',
      name: 'years',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `User Loaded`
  String get userLoaded {
    return Intl.message(
      'User Loaded',
      name: 'userLoaded',
      desc: '',
      args: [],
    );
  }

  /// `Assigned tasks`
  String get assignedTasks {
    return Intl.message(
      'Assigned tasks',
      name: 'assignedTasks',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get employeeNameLabel {
    return Intl.message(
      'Name',
      name: 'employeeNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Contact Number`
  String get contactNumberLabel {
    return Intl.message(
      'Contact Number',
      name: 'contactNumberLabel',
      desc: '',
      args: [],
    );
  }

  /// `Work Experience`
  String get workExperienceLabel {
    return Intl.message(
      'Work Experience',
      name: 'workExperienceLabel',
      desc: '',
      args: [],
    );
  }

  /// `Due Date`
  String get dueDate {
    return Intl.message(
      'Due Date',
      name: 'dueDate',
      desc: '',
      args: [],
    );
  }

  /// `Start Time`
  String get startTime {
    return Intl.message(
      'Start Time',
      name: 'startTime',
      desc: '',
      args: [],
    );
  }

  /// `Start Service`
  String get startService {
    return Intl.message(
      'Start Service',
      name: 'startService',
      desc: '',
      args: [],
    );
  }

  /// `Client Address`
  String get clientAddress {
    return Intl.message(
      'Client Address',
      name: 'clientAddress',
      desc: '',
      args: [],
    );
  }

  /// `Landmark`
  String get landmark {
    return Intl.message(
      'Landmark',
      name: 'landmark',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get contact {
    return Intl.message(
      'Contact',
      name: 'contact',
      desc: '',
      args: [],
    );
  }

  /// `Entry Instructions`
  String get entryInstructions {
    return Intl.message(
      'Entry Instructions',
      name: 'entryInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Wait outside the gate facing the camera and call me directly.`
  String get entryInstructionsDetail {
    return Intl.message(
      'Wait outside the gate facing the camera and call me directly.',
      name: 'entryInstructionsDetail',
      desc: '',
      args: [],
    );
  }

  /// `Services`
  String get services {
    return Intl.message(
      'Services',
      name: 'services',
      desc: '',
      args: [],
    );
  }

  /// `No services booked`
  String get noServices {
    return Intl.message(
      'No services booked',
      name: 'noServices',
      desc: '',
      args: [],
    );
  }

  /// `Size`
  String get size {
    return Intl.message(
      'Size',
      name: 'size',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get products {
    return Intl.message(
      'Products',
      name: 'products',
      desc: '',
      args: [],
    );
  }

  /// `No products ordered`
  String get noProducts {
    return Intl.message(
      'No products ordered',
      name: 'noProducts',
      desc: '',
      args: [],
    );
  }

  /// `Delivery`
  String get delivery {
    return Intl.message(
      'Delivery',
      name: 'delivery',
      desc: '',
      args: [],
    );
  }

  /// `Make sure to pick`
  String get makeSureToPick {
    return Intl.message(
      'Make sure to pick',
      name: 'makeSureToPick',
      desc: '',
      args: [],
    );
  }

  /// `Mop`
  String get mop {
    return Intl.message(
      'Mop',
      name: 'mop',
      desc: '',
      args: [],
    );
  }

  /// `Broom`
  String get broom {
    return Intl.message(
      'Broom',
      name: 'broom',
      desc: '',
      args: [],
    );
  }

  /// `Standing Ladder`
  String get standingLadder {
    return Intl.message(
      'Standing Ladder',
      name: 'standingLadder',
      desc: '',
      args: [],
    );
  }

  /// `Cleaning Liquid`
  String get cleaningLiquid {
    return Intl.message(
      'Cleaning Liquid',
      name: 'cleaningLiquid',
      desc: '',
      args: [],
    );
  }

  /// `Cloth`
  String get cloth {
    return Intl.message(
      'Cloth',
      name: 'cloth',
      desc: '',
      args: [],
    );
  }

  /// `You’re missing out!!!`
  String get youAreMissingout {
    return Intl.message(
      'You’re missing out!!!',
      name: 'youAreMissingout',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe and save.`
  String get subscribeAndsave {
    return Intl.message(
      'Subscribe and save.',
      name: 'subscribeAndsave',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Plans`
  String get subscriptionPlans {
    return Intl.message(
      'Subscription Plans',
      name: 'subscriptionPlans',
      desc: '',
      args: [],
    );
  }

  /// `Our Services`
  String get ourServices {
    return Intl.message(
      'Our Services',
      name: 'ourServices',
      desc: '',
      args: [],
    );
  }

  /// `Recommended Products`
  String get recommendedProducts {
    return Intl.message(
      'Recommended Products',
      name: 'recommendedProducts',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching user details`
  String get errorFetchingUserDetails {
    return Intl.message(
      'Error fetching user details',
      name: 'errorFetchingUserDetails',
      desc: '',
      args: [],
    );
  }

  /// `Guest User`
  String get guestUser {
    return Intl.message(
      'Guest User',
      name: 'guestUser',
      desc: '',
      args: [],
    );
  }

  /// `My Profile`
  String get myProfile {
    return Intl.message(
      'My Profile',
      name: 'myProfile',
      desc: '',
      args: [],
    );
  }

  /// `Manage Address`
  String get manageAddress {
    return Intl.message(
      'Manage Address',
      name: 'manageAddress',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Conditions`
  String get termsAndConditions {
    return Intl.message(
      'Terms & Conditions',
      name: 'termsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logOut {
    return Intl.message(
      'Log out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `No user details found.`
  String get noUserDetailsFound {
    return Intl.message(
      'No user details found.',
      name: 'noUserDetailsFound',
      desc: '',
      args: [],
    );
  }

  /// `Personal details`
  String get personalDetails {
    return Intl.message(
      'Personal details',
      name: 'personalDetails',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Manage Addresses`
  String get manageAddresses {
    return Intl.message(
      'Manage Addresses',
      name: 'manageAddresses',
      desc: '',
      args: [],
    );
  }

  /// `No addresses available.`
  String get noAddressesAvailable {
    return Intl.message(
      'No addresses available.',
      name: 'noAddressesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Add New Address`
  String get addNewAddress {
    return Intl.message(
      'Add New Address',
      name: 'addNewAddress',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Re-enter New Password`
  String get reEnterNewPassword {
    return Intl.message(
      'Re-enter New Password',
      name: 'reEnterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePasswordButton {
    return Intl.message(
      'Change Password',
      name: 'changePasswordButton',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get reviews {
    return Intl.message(
      'Reviews',
      name: 'reviews',
      desc: '',
      args: [],
    );
  }

  /// `Service`
  String get service {
    return Intl.message(
      'Service',
      name: 'service',
      desc: '',
      args: [],
    );
  }

  /// `Select Date`
  String get selectDate {
    return Intl.message(
      'Select Date',
      name: 'selectDate',
      desc: '',
      args: [],
    );
  }

  /// `Select Time`
  String get selectTime {
    return Intl.message(
      'Select Time',
      name: 'selectTime',
      desc: '',
      args: [],
    );
  }

  /// `Tomorrow`
  String get tomorrow {
    return Intl.message(
      'Tomorrow',
      name: 'tomorrow',
      desc: '',
      args: [],
    );
  }

  /// `AM`
  String get am {
    return Intl.message(
      'AM',
      name: 'am',
      desc: '',
      args: [],
    );
  }

  /// `PM`
  String get pm {
    return Intl.message(
      'PM',
      name: 'pm',
      desc: '',
      args: [],
    );
  }

  /// `Time Availability`
  String get timeAvailability {
    return Intl.message(
      'Time Availability',
      name: 'timeAvailability',
      desc: '',
      args: [],
    );
  }

  /// `Available From`
  String get availableFrom {
    return Intl.message(
      'Available From',
      name: 'availableFrom',
      desc: '',
      args: [],
    );
  }

  /// `Available To`
  String get availableTo {
    return Intl.message(
      'Available To',
      name: 'availableTo',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get choose {
    return Intl.message(
      'Choose',
      name: 'choose',
      desc: '',
      args: [],
    );
  }

  /// `Bookings`
  String get bookings {
    return Intl.message(
      'Bookings',
      name: 'bookings',
      desc: '',
      args: [],
    );
  }

  /// `In Process`
  String get inProcess {
    return Intl.message(
      'In Process',
      name: 'inProcess',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message(
      'Completed',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled`
  String get cancelled {
    return Intl.message(
      'Cancelled',
      name: 'cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message(
      'Pending',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Enter Location`
  String get enterLocation {
    return Intl.message(
      'Enter Location',
      name: 'enterLocation',
      desc: '',
      args: [],
    );
  }

  /// `Enter location`
  String get enterLocationHint {
    return Intl.message(
      'Enter location',
      name: 'enterLocationHint',
      desc: '',
      args: [],
    );
  }

  /// `Use Current Location`
  String get useCurrentLocation {
    return Intl.message(
      'Use Current Location',
      name: 'useCurrentLocation',
      desc: '',
      args: [],
    );
  }

  /// `Building Number`
  String get buildingNumber {
    return Intl.message(
      'Building Number',
      name: 'buildingNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter building number`
  String get enterBuildingNumberHint {
    return Intl.message(
      'Enter building number',
      name: 'enterBuildingNumberHint',
      desc: '',
      args: [],
    );
  }

  /// `Floor`
  String get floor {
    return Intl.message(
      'Floor',
      name: 'floor',
      desc: '',
      args: [],
    );
  }

  /// `Enter your floor`
  String get enterFloorHint {
    return Intl.message(
      'Enter your floor',
      name: 'enterFloorHint',
      desc: '',
      args: [],
    );
  }

  /// `Enter landmark`
  String get enterLandmarkHint {
    return Intl.message(
      'Enter landmark',
      name: 'enterLandmarkHint',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Address saved successfully.`
  String get addressSaved {
    return Intl.message(
      'Address saved successfully.',
      name: 'addressSaved',
      desc: '',
      args: [],
    );
  }

  /// `Save Address`
  String get saveAddress {
    return Intl.message(
      'Save Address',
      name: 'saveAddress',
      desc: '',
      args: [],
    );
  }

  /// `Reached`
  String get reached {
    return Intl.message(
      'Reached',
      name: 'reached',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Could not launch dialer`
  String get couldNotLaunchDialer {
    return Intl.message(
      'Could not launch dialer',
      name: 'couldNotLaunchDialer',
      desc: '',
      args: [],
    );
  }

  /// `Photo uploaded successfully`
  String get photoUploadedSuccessfully {
    return Intl.message(
      'Photo uploaded successfully',
      name: 'photoUploadedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to upload photo`
  String get failedToUploadPhoto {
    return Intl.message(
      'Failed to upload photo',
      name: 'failedToUploadPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Upload & Complete`
  String get uploadAndComplete {
    return Intl.message(
      'Upload & Complete',
      name: 'uploadAndComplete',
      desc: '',
      args: [],
    );
  }

  /// `No image selected`
  String get noImageSelected {
    return Intl.message(
      'No image selected',
      name: 'noImageSelected',
      desc: '',
      args: [],
    );
  }

  /// `Retake`
  String get retake {
    return Intl.message(
      'Retake',
      name: 'retake',
      desc: '',
      args: [],
    );
  }

  /// `Order Overview`
  String get orderOverview {
    return Intl.message(
      'Order Overview',
      name: 'orderOverview',
      desc: '',
      args: [],
    );
  }

  /// `Great Job!`
  String get greatJob {
    return Intl.message(
      'Great Job!',
      name: 'greatJob',
      desc: '',
      args: [],
    );
  }

  /// `Service completed successfully.`
  String get serviceCompletedSuccessfully {
    return Intl.message(
      'Service completed successfully.',
      name: 'serviceCompletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Back to home`
  String get backToHome {
    return Intl.message(
      'Back to home',
      name: 'backToHome',
      desc: '',
      args: [],
    );
  }

  /// `Remaining`
  String get remaining {
    return Intl.message(
      'Remaining',
      name: 'remaining',
      desc: '',
      args: [],
    );
  }

  /// `Km's`
  String get kms {
    return Intl.message(
      'Km\'s',
      name: 'kms',
      desc: '',
      args: [],
    );
  }

  /// `ETA Time`
  String get etaTime {
    return Intl.message(
      'ETA Time',
      name: 'etaTime',
      desc: '',
      args: [],
    );
  }

  /// `Select Location`
  String get selectLocation {
    return Intl.message(
      'Select Location',
      name: 'selectLocation',
      desc: '',
      args: [],
    );
  }

  /// `Location Outside Riyadh`
  String get locationOutsideRiyadh {
    return Intl.message(
      'Location Outside Riyadh',
      name: 'locationOutsideRiyadh',
      desc: '',
      args: [],
    );
  }

  /// `Please select a location within Riyadh.`
  String get selectLocationMessage {
    return Intl.message(
      'Please select a location within Riyadh.',
      name: 'selectLocationMessage',
      desc: '',
      args: [],
    );
  }

  /// `No location selected. Please select a location within Riyadh.`
  String get noLocationSelected {
    return Intl.message(
      'No location selected. Please select a location within Riyadh.',
      name: 'noLocationSelected',
      desc: '',
      args: [],
    );
  }

  /// `Failed to get the current location.`
  String get failedToGetLocation {
    return Intl.message(
      'Failed to get the current location.',
      name: 'failedToGetLocation',
      desc: '',
      args: [],
    );
  }

  /// `Upload After Images`
  String get uploadAfterImages {
    return Intl.message(
      'Upload After Images',
      name: 'uploadAfterImages',
      desc: '',
      args: [],
    );
  }

  /// `Service Completed`
  String get serviceCompleted {
    return Intl.message(
      'Service Completed',
      name: 'serviceCompleted',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
