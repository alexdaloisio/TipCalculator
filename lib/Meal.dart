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

  //TODO total that is the sum of the totalPrice of the diners
  double trueTotal;

  Function updateParent;
  Function deleteEntry;

  bool isRounded = false; //Are we going to round the results to nearest $

  //TODO:Needs to have a list of final prices

  TextEditingController subTotalController = TextEditingController();
  TextEditingController tipRateController = TextEditingController();
  TextEditingController taxController = TextEditingController();

  Meal(List<Diner> diners, double subTotal, double tipRate, double tax,
      double fullTotal) {
    this.diners = diners;
    this.subTotal = subTotal;
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

  void updateFunction(Function func) {
    this.updateParent = func;
  }

  void updateDeleteFunction(Function func) {
    this.deleteEntry = func;
  }

  // adds a default diner to a list of diners
  void addDiner() {
    diners.add(Diner.defaultDiner());
  }

  List<Widget> buildAllDinerResults() {
    List<Widget> result = <Widget>[];

    for (Diner din in diners) {
      result.add(DinerRowResult(din));
    }

    return result;
  }

  List<Widget> buildAllDinerInputs() {
    List<Widget> result = <Widget>[];

    for (Diner din in diners) {
      result.add(DinerRowInput(din, this));
    }

    return result;
  }

  // returns a list of all Diners for this current meal
  List<Widget> buildAllDiners() {
    List<Widget> result = <Widget>[];

    for (Diner din in diners) {
      result.add(DinerRow(din, this, updateParent, deleteEntry));
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
    //TODO think more about these conditions
    // subtotal and tax are fulled in, all Diners have an order, and subtotal
    // and dinners sumOfitems are equal
    if (true) {
      //this.subTotal > 0) {

      // This computes the price for unrounded totals
      if (!isRounded) {
        double totalPrice = this.sumOfItems();

        if (totalPrice == 0) {
          for (int i = 0; i < diners.length; i++) {
            diners[i].totalPrice = 0;
          }
        } else {
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
          //TODO: make sure that checkTotalPrices is only called when subtotal is there,
          //TODO can do it below or for the entire function
          this.checkTotalPrices(paidSum);
        }
      }
      // Live rounding (while user inputs) seems unwise, hard to decide on changing tip or adding cents to a total price.
      else {
        this.updateRoundedPrices();
      }
    }
  }

  //TODO: have it so rounding prices will change the tip to the correct price to make them even
  //TODO: have alert come up to show user the tip change to get everyone to an even dollar, can select no, in that case the user decides if the 50 cents should be added
  //TODO: or if tip should be rounded up
  //THis will return the difference in how much is being paid with rounded price and how much needs to be paid
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
    return roundDouble(this.sumOfItems() - this.subTotal, 2);
  }

  void fixRoundedTotals(double dif) {
    if ((this.sumOfItems() - this.subTotal).abs() < 0.00001) {
      //fix rounding
    }
    //else do nothing
  }

  // checks for rounding errors
  void checkTotalPrices(double paidSum) {
    //TODO check these, they seem kind of ehhh

    //We only want to run these checks if the user entered suffi, I.e the user entered the correct amount of information
    if ((this.sumOfItems() - this.subTotal).abs() < 0.00001) {
      // paidSum exceeds actual amount
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
        print('bot');
        while (dif > 0) {
          if (i >= diners.length) {
            i = 0;
            print('entered loop');
          }
          print(i);
          print(diners.length);
          diners[i].totalPrice += 0.01;
          dif -= 0.01;
          i++;
        }
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

  //Returns sumofTotalPrices of diners
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
