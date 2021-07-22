/**
 * this controller retrieve the total amount of Team Orders 
 * */

public with sharing class MyTeamOrdersController {
    private Decimal amount;
    
    public MyTeamOrdersController(){
        AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order where status='Activated'];
        this.amount = (decimal)groupedResults.get('total');
    }
    public decimal getSumOrders(){
        return amount;
    }
}
