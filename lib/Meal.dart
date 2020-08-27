//import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tipcalculator/Diner.dart';
import 'dart:math';

class Meal {

  List<Diner> diners;
  double subTotal;
  double tipRate;
  double tax;
  double fullTotal;

  Function updateParent;

  TextEditingController subTotalController = TextEditingController();
  TextEditingController tipRateController = TextEditingController();
  TextEditingController taxController = TextEditingController();

  Meal(List<Diner> diners, double subTotal, double tipRate, double tax,
      double fullTotal) {
    this.diners = diners;
    this.subTotal = 0;
    this.tipRate = tipRate;
    this.tax = tax;
    this.fullTotal = fullTotal;
  }

  // new (fresh) meal
  Meal.fresh(List<Diner> diners) {
    this.diners = diners;
    this.subTotal = 0;
    this.tipRate = 0;
    this.tax = 0;
    this.fullTotal = 0;
  }

  // Allows us to change the highest parent function of the current page
  // So we can pass a setState function and have the highest parent
  // re render when a child is changed
  void updateFunction(Function func) {
    this.updateParent = func;
  }


  // adds a default diner to a list of diners
  void addDiner() {
    diners.add(Diner.defaultDiner());
  }

  // Builds the list of Diner results for the final page
  List<Widget> buildAllDinerResults() {
    List<Widget> result = <Widget>[];

    for (Diner din in diners) {
      result.add(DinerRowResult(din));
    }

    return result;
  }

  // builds the list of diner inputs for the second page
  List<Widget> buildAllDinerInputs() {
    List<Widget> result = <Widget>[];

    for (Diner din in diners) {
      result.add(DinerRowInput(din, this));
    }

    return result;
  }


  // updates one of the tip tax or subtotal based on input
  void updateOneOfThree(String text, double newValue) {
    if (text.compareTo('Tip Rate (ex: 20%)') == 0) {
      this.tipRate = newValue / 100;
    } else if (text.compareTo('Subtotal') == 0) {
      this.subTotal = newValue;
    } else if (text.compareTo('Tax') == 0) {
      this.tax = newValue;
    } else {}
  }

  // Updates the total based on 3 other doubles
  void updateTotal() {
    this.fullTotal = subTotal + tax + tipRate * subTotal;
  }

  // Update TotalPrice for the Diners un-rounded
  void updateTotalPrice() {
        double totalPrice = this.sumOfItems();

        if (totalPrice == 0) {
          for (int i = 0; i < diners.length; i++) {
            diners[i].totalPrice = 0;
          }

        }

        else {
          // How much the Diners pay according to these calculations
          // want to avoid the chance the rounding requires them to pay less or more
          double paidSum = 0;

          for (int i = 0; i < diners.length; i++) {
            double prop = diners[i].sumOfItems / totalPrice;
            double res = prop * this.tipRate * this.subTotal +
                prop * this.tax +
                diners[i].sumOfItems;
            res = roundDouble(res, 2);
            this.diners[i].totalPrice = res;
            paidSum += res;
          }

      }
  }

  //This will return the difference in how much is being paid with rounded price and how much needs to be paid
  double updateRoundedPrices() {
    double totalPrice = this.sumOfItems();
    double paidSum = 0;
    if (totalPrice == 0) {
      for (int i = 0; i < diners.length; i++) {
        diners[i].totalPrice = 0;
      }
    } else {
      for (int i = 0; i < diners.length; i++) {
        double prop = diners[i].sumOfItems / totalPrice;
        double res = prop * this.tipRate * this.subTotal +
            prop * this.tax +
            diners[i].sumOfItems;
        res = roundDouble(res, 2);
        this.diners[i].totalPrice = roundDouble(res, 0);
        paidSum += roundDouble(res, 0);
      }
    }
    return roundDouble(this.sumOfTotalPrices() - this.fullTotal, 2);
  }

  // checks for rounding errors in calculating the unrounded result,
  // because we truncate to 2 decimal points we prevent situations such as
  // 1 / 3 = 0.33, we add the extra cent so the totals are correct
  void checkTotalPrices(double paidSum) {



      if (paidSum - this.fullTotal >= 0.009) {
        double dif = roundDouble(paidSum - this.fullTotal, 2);
        print('top');
        int i = 0;
        while (dif > 0) {
          if (i >= diners.length) {
            i = 0;
          }
          diners[i].totalPrice -= 0.01;
          dif -= 0.01;
          i++;
        }
      }

      // paidsum is under actual amount
      else if (this.fullTotal - paidSum >= 0.009) {
        double dif = roundDouble(this.fullTotal - paidSum, 2);
        int i = 0;
        while (dif > 0) {
          if (i >= diners.length) {
            i = 0;
          }
          diners[i].totalPrice += 0.01;
          dif -= 0.01;
          i++;
        }
      }
  }

  //checks to make sure that all diners have a sum of items field that is not 0
  bool allHaveSumOfItems() {
    for (Diner din in this.diners) {
      if (din.sumOfItems == 0) {
        return false;
      }
    }
    return true;
  }

  // Returns the sumOfItems for all diners in this meal
  double sumOfItems() {
    double sum = 0;

    for (Diner din in this.diners) {
      sum += din.sumOfItems;
    }
    return sum;
  }

  //Returns sum of TotalPrices of diners
  double sumOfTotalPrices() {
    double sum = 0;

    for (Diner din in this.diners) {
      sum += din.totalPrice;
    }
    return sum;
  }

  //We use this to round totals to make sure they add up to the fullTotal
  double roundDouble(double value, int places) {
    double shift = pow(10.0, places);
    return ((value * shift).round().toDouble() / shift);
  }
}
