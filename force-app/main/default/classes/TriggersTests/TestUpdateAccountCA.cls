@isTest
public with sharing class TestUpdateAccountCA {
    @isTest
    static void updateOrderTest() {
        //Test data setup
        Integer numberOfAccounts = 2;
        Integer unitPrice = 1000;
        Integer numberOfitems = 7;
        TestDataFactory.accountGen(numberOfAccounts,unitPrice, numberOfitems);

        //Perform test
        Test.startTest();
        List<OrderItem> ordersItems = [Select Quantity, TotalPrice from OrderItem];
        for(OrderItem oI: ordersItems){
            oI.Quantity = oI.Quantity +1;
        }
        update ordersItems;
        
       List<Order> updateOrder = [Select Description, Id from Order];
        for(Order o:updateOrder){
            o.Description = 'New Description';
        }
        update updateOrder;
        Test.stopTest();

        // Verify 
        // In this case verify that the NetAmount__c is well updated     
        List<Account> assAccountList = [Select Id, Chiffre_d_affaire__c from Account];
        System.AssertEquals( ((numberOfitems + 1 ) * unitPrice) , assAccountList[0].Chiffre_d_affaire__c);
        System.AssertEquals( ((numberOfitems + 1 ) * unitPrice) , assAccountList[1].Chiffre_d_affaire__c);
    }
}
