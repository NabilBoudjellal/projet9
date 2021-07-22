/**
 * this triger calculates the net amount before updating a new order 
 */
trigger AmountTriggerCalculation on Order (before update) {
    For(Order o : Trigger.New){
        o.NetAmount__c = o.TotalAmount - o.ShipmentCost__c;
    }
}

/**
 * ca que j'ai fait :
 * -- création des champs NetAmount__c et ShipmentCost__c dans l'objet order, du fait qu'ils n'existaient pas au départ
 * -- modification de nom du trigger en anglais
 * -- ajout d'un commentaire pour expliquer le fonctionnement du trigger
 * -- j'ai aussi utiliser une liste au lieu d'un simple objet pour que le trigger se déclanche et agit quant plus qu'un objet et modifier
 */