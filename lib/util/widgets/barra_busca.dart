import 'package:flutter/material.dart';

Widget barraDeBusca() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: TextField(
      //onChanged: (texto) => buscarItem(texto),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0),
        prefixIcon: Icon(
          Icons.search,
          size: 20,
        ),
        prefixIconConstraints: BoxConstraints(
          maxHeight: 20,
          minWidth: 20,
        ),
        border: InputBorder.none,
        hintText: 'Buscar',
      ),
    ),
  );
}