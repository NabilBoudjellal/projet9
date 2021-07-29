/**
 * this triger calculates the net amount before updating a new order 
 */
trigger AmountTriggerCalculation on Order (before update) {
    For(Order o : Trigger.New){
        if(o.ShipmentCost__c != null){
            o.NetAmount__c = o.TotalAmount - o.ShipmentCost__c;
        }else {
            o.NetAmount__c = o.TotalAmount;
        }
        
    }
}
