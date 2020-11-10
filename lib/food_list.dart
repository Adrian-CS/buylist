import 'package:food/db/database_provider.dart';
import 'package:food/events/delete_food.dart';
import 'package:food/events/set_foods.dart';
import 'package:food/food_form.dart';
import 'package:food/model/food.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/food_bloc.dart';

class FoodList extends StatefulWidget {
  const FoodList({Key key}) : super(key: key);

  @override
  _FoodListState createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db4.getFoods().then(
      (foodList) {
        BlocProvider.of<FoodBloc>(context).add(SetFoods(foodList));
      },
    );
  }

  showFoodDialog(BuildContext context, Food food, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey,
        title: Text(
          food.name,
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          " ${food.supermarket} \n Cantidad:  ${food.quantity}",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FoodForm(food: food, foodIndex: index),
              ),
            ),
            child: Text(
              "Actualizar",
              style: TextStyle(color: Colors.pink[100]),
            ),
          ),
          FlatButton(
            onPressed: () => DatabaseProvider.db4.delete(food.id).then((_) {
              BlocProvider.of<FoodBloc>(context).add(
                DeleteFood(index),
              );
              Navigator.pop(context);
            }),
            child: Text("Borrar", style: TextStyle(color: Colors.pink[100])),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar", style: TextStyle(color: Colors.pink[100])),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building entire food list scaffold");
    return Scaffold(
      appBar: AppBar(title: Text("FoodList")),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/fondo.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocConsumer<FoodBloc, List<Food>>(
          builder: (context, foodList) {
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                print("foodList: $foodList");

                Food food = foodList[index];
                return ListTile(
                    title: Text(food.name,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            backgroundColor: Colors.black)),
                    subtitle: Text(
                      "Cantidad: ${food.quantity}\nSuper: ${food.supermarket}",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          backgroundColor: Colors.black),
                    ),
                    onTap: () => showFoodDialog(context, food, index));
              },
              itemCount: foodList.length,
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(color: Colors.black),
            );
          },
          listener: (BuildContext context, foodList) {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => FoodForm()),
        ),
      ),
    );
  }
}
