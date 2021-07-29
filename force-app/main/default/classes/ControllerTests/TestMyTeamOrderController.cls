@isTest
public with sharing class TestMyTeamOrderController {
    testmethod static void testController() {
        //Creating the required data.
        //each account has one order
        Integer numberOfAccounts = 2;
        Integer unitPrice = 1000;
        Integer numberOfitems = 7;
        TestDataFactory.accountGen(numberOfAccounts,unitPrice, numberOfitems);

        //starting the test
        Test.startTest();

        PageReference pageRef = Page.MyTeamOrders; // MyTeamOrders is the name of my vf page
        Test.setCurrentPage(pageRef);
        MyTeamOrdersController myTeamOrderController = new MyTeamOrdersController();
        Decimal sumAmount = myTeamOrderController.getSumOrders();
        Test.stopTest();
        
        //assert the result
        System.assertEquals(sumAmount, (numberOfAccounts*unitPrice*numberOfitems) );
    }
}