import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:user/models/addressModel.dart';
import 'package:user/screens/add_address_screen.dart';

class AddressInfoCard extends StatefulWidget {
  final key;
  @required
  final bool isSelected;
  final value;
  final Address groupValue;
  final Function(Address) onChanged;
  final Address address;
  final dynamic analytics;
  final dynamic observer;

  AddressInfoCard({this.value, this.groupValue, this.isSelected, this.onChanged, this.address, this.key, this.analytics, this.observer}) : super();

  @override
  _AddressInfoCardState createState() => _AddressInfoCardState(isSelected: isSelected, value: value, groupValue: groupValue, onChanged: onChanged, address: address, key: key, analytics: analytics, observer: observer);
}

class _AddressInfoCardState extends State<AddressInfoCard> {
  bool isSelected;
  var value;
  Address groupValue;
  Function(Address) onChanged;
  Address address;
  Key key;
  dynamic analytics;
  dynamic observer;

  _AddressInfoCardState({this.value, this.groupValue, this.isSelected, this.onChanged, this.address, this.key, this.analytics, this.observer});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    TextStyle subHeadingStyle = textTheme.subtitle1.copyWith(
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    return Card(
      elevation: isSelected ? 5 : 0,
      color: isSelected ? Colors.white : Color(0xffF6F6F6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Radio(
                key: key,
                value: value,
                groupValue: groupValue,
                onChanged: (value) => onChanged(value),
              ),
              SizedBox(width: 8),
              Text(
                address.type,
                style: subHeadingStyle,
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: InkWell(
                  onTap: () => Get.to(() => AddAddressScreen(
                        address,
                        a: widget.analytics,
                        o: widget.observer,
                        screenId: 0,
                      )),
                  child: Icon(
                    Icons.edit_outlined,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              '${address.houseNo} ${address.society} ${address.city} ${address.state} ${address.pincode}',
              style: textTheme.bodyText1.copyWith(fontSize: 15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 16,
              bottom: 16,
            ),
            child: Text(
              address.receiverPhone,
              style: textTheme.caption.copyWith(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
