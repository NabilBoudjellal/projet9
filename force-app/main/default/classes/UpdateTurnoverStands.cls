/**
 * this class contains methods for updating the turn over stand of a set of accounts
 */
public with sharing class UpdateTurnoverStands {
    public static void UpdateTurnoverStandsMethod(Set<Id> accountSet){
        List<Account> accountActiveOrders = [select id from account where id in:accountSet];
        list<Order> listOrders =  [SELECT Id, TotalAmount, AccountId FROM Order where AccountId in:accountSet and status='Activated'];

        for(Account a:accountActiveOrders){
            Decimal i=0;
            for(Order o:listOrders){
                if(a.Id == o.AccountId){
                    i = i + o.TotalAmount;
                }
                a.Chiffre_d_affaire__c = i;
            }
        }
        update accountActiveOrders;
    }
}
