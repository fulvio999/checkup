/*
   Function to calculate BMI value
*/
function calculateBmi(weight, height, weightUnitOfMeasure, heigthUnitOfMeasure){

    //Convert all units to metric: 'Kg' and 'cm'
    if (heigthUnitOfMeasure == "in")
        height = height * 2.54; //convert to cm

    if (weightUnitOfMeasure == "lb")
        weight = weight * 0.453592; //convert to KG

    //console.log("Calculating BMI using weight:"+weight+", height:"+height+", weightUnitOfMeasure:"+weightUnitOfMeasure+ ", heigthUnitOfMeasure:"+heigthUnitOfMeasure)

    /* heigth must be calcauted using cm and kg */
    var BMI = weight / Math.pow(height/100, 2);

    return parseFloat(BMI).toFixed(3);
}

/* from a BMI numeric value get his textual description */
function getBmiDescription(bmiValue,i18n){

  if (bmiValue < 18.5){
     return i18n.tr("Underweight");
  }

  if (bmiValue >= 18.5 && bmiValue <= 25){
     return i18n.tr("Normal");
  }
  if (bmiValue >= 25 && bmiValue <= 30){
     return i18n.tr("Obese");
  }
  if (bmiValue > 30){
     return i18n.tr("Overweight");
  }

}
