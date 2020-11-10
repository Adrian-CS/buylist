import 'package:food/bloc/food_bloc.dart';
import 'package:food/db/database_provider.dart';
import 'package:food/events/add_food.dart';
import 'package:food/events/update_food.dart';
import 'package:food/model/food.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodForm extends StatefulWidget {
  final Food food;
  final int foodIndex;

  FoodForm({this.food, this.foodIndex});

  @override
  State<StatefulWidget> createState() {
    return FoodFormState();
  }
}

class FoodFormState extends State<FoodForm> {
  String _name;
  String _quantity;
  String _supermarket = "Mercadona";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      initialValue: _name,
      decoration: InputDecoration(
        labelText: 'Nombre',
        labelStyle: TextStyle(color: Colors.white),
      ),
      maxLength: 30,
      style: TextStyle(fontSize: 28, color: Colors.white),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Falta nommbre del producto';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildQuantity() {
    return TextFormField(
      initialValue: "1",
      decoration: InputDecoration(
        labelText: 'Cantidad',
        labelStyle: TextStyle(color: Colors.white),
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28, color: Colors.white),
      validator: (String value) {
        int quantity = int.tryParse(value);

        if (quantity == null || quantity <= 0) {
          return 'La cantidad debe ser mayor que cero';
        }

        return null;
      },
      onSaved: (String value) {
        _quantity = value;
      },
    );
  }

  Widget _buildSupermarket() {
    return Container(
        padding: EdgeInsets.all(10),
        width: 600,
        child: DropdownButton<String>(
            value: _supermarket,
            style: TextStyle(
                color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
            dropdownColor: Colors.black,
            items: [
              DropdownMenuItem(
                child: Text("Mercadona"),
                value: "Mercadona",
              ),
              DropdownMenuItem(
                child: Text("Hiperdino"),
                value: "Hiperdino",
              ),
              DropdownMenuItem(
                child: Text("Frutería"),
                value: "Frutería",
              ),
              DropdownMenuItem(
                child: Text("Carrefour"),
                value: "Carrefour",
              ),
              DropdownMenuItem(
                child: Text("Otros"),
                value: "Otros",
              ),
            ],
            onChanged: (value) {
              setState(() {
                _supermarket = value;
              });
            }));
  }

  @override
  void initState() {
    super.initState();
    if (widget.food != null) {
      _name = widget.food.name;
      _quantity = widget.food.quantity;
      _supermarket = widget.food.supermarket;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("Food Form")),
      body: Container(
        height: 3200,
        width: 4000,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/fondo.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(48, 48, 48, 0.2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildName(),
                  _buildQuantity(),
                  SizedBox(height: 16),
                  _buildSupermarket(),
                  SizedBox(height: 20),
                  widget.food == null
                      ? RaisedButton(
                          color: Colors.pink,
                          child: Text(
                            'Añadir',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }

                            _formKey.currentState.save();

                            Food food = Food(
                              name: _name,
                              quantity: _quantity,
                              supermarket: _supermarket,
                            );

                            DatabaseProvider.db4.insert(food).then(
                                  (storedFood) =>
                                      BlocProvider.of<FoodBloc>(context).add(
                                    AddFood(storedFood),
                                  ),
                                );

                            Navigator.pop(context);
                          },
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(
                              color: Colors.pink,
                              child: Text(
                                "Actualizar",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () {
                                if (!_formKey.currentState.validate()) {
                                  print("form");
                                  return;
                                }

                                _formKey.currentState.save();

                                Food food = Food(
                                  name: _name,
                                  quantity: _quantity,
                                  supermarket: _supermarket,
                                );

                                DatabaseProvider.db4.update(widget.food).then(
                                      (storedFood) =>
                                          BlocProvider.of<FoodBloc>(context)
                                              .add(
                                        UpdateFood(widget.foodIndex, food),
                                      ),
                                    );

                                Navigator.pop(context);
                              },
                            ),
                            RaisedButton(
                              color: Colors.pink[100],
                              child: Text(
                                "Cancelar",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
