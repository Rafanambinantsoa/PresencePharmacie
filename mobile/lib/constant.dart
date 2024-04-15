import 'package:flutter/material.dart';

const baseURL = 'http://192.168.43.220:8000/api';
String imgUrl = 'http://192.168.43.220:8000/';
const loginURL = baseURL + '/loginApi';
const logout = baseURL + '/logout';
const userURL = baseURL + '/userGet';

const infoOneTicketUrl = baseURL + '/ticketInfo/';

const serverError = "Server Error";
const unauthorized = "Unauthorized";
const somethingWentWrong = "Something went wrong , try again";

//Decoration input login
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10)));
}
