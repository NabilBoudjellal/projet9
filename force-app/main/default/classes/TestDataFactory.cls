/**
 * This class is dedicated to generate data that will be used in the tests
 */
@isTest
public with sharing class TestDataFactory {
    public static void accountGen(Integer nombre_de_comptes,Integer price, Integer itemQte){
        accountGen(nombre_de_comptes);
        contractGen();
        activateContract();
        product_and_PricebookEntry_Gen(price);
        orderGen();
        itemOrdersGen(itemQte);
        activateOrders();
    }
    public static void accountGen(Integer n){
        List<Account> l = new List<Account>();
        for(Integer i=0;i<n;i++){
            l.add(new Account(Name = 'Account_'+i));
        }
        insert l;
    }
    public static void contractGen(){
        //récupération de la liste des comptes créer
        List<Account> createdAccount = [select id from account];
        //création des contrats en fonction des comptes
        List<Contract> listContract = new List<Contract>();

        for(Account a:createdAccount){
            listContract.add(new Contract(AccountId= a.id,
                                            Status='Draft',
                                            StartDate= Date.newInstance(2021, 01, 01),
                                            ContractTerm=2000
                                            ));
        }
        insert listContract;
    }
    public static void activateContract(){
        List<Contract> listContract =[select id from contract];
        for(Contract c: listContract){
            c.status = 'Activated';
        }
        update listContract;
    }

    public static void product_and_PricebookEntry_Gen(Integer price){
        Product2 prod = new Product2(Name='Product', 
                                        Family='TestFamily', 
                                        isActive=true);
        insert prod;
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(),
                                                Product2Id=prod.Id,
                                                UnitPrice= price,
                                                IsActive = true);
        insert pbe1;
    }
    public static void orderGen(){
        List<Account> createdAccount = [select id, name from account];
        List<Order> orders = new List<Order>();
        for(Account a: createdAccount){
            orders.add(new Order(Name = a.name+'cmd', 
                                AccountId= a.id,
                                Pricebook2Id=Test.getStandardPricebookId(),
                                EffectiveDate = Date.newInstance(2022, 03, 27),
                                Status = 'Draft'));
        }
        insert orders;
        List<Contract> contractList =[select id, accountId from contract];
        for(Order o : orders){
            for(Contract c: contractList){
                if(o.AccountId == c.AccountId){
                    o.ContractId = c.id;
                }
            }
        }
        update orders;
    }
    public static void itemOrdersGen(Integer itemQte){
        List<Order> orders = [select id from order];
        PricebookEntry pbe = [select id, UnitPrice,Product2Id from PricebookEntry limit 1];

        System.debug('je suis là '+pbe.id);

        List<OrderItem> orderItemtest = new List<OrderItem>();
        for(Order o: orders){
                orderItemtest.add(new OrderItem(Product2Id = pbe.Product2Id,
                                  				OrderId = o.id,
                                  				PricebookEntryId = pbe.id,
                                  				UnitPrice = pbe.UnitPrice,
                                  				Quantity= itemQte));
        }
        insert orderItemtest;
    }
    public static void activateOrders(){
        List<Order> orders = [select id, status from order];
        for(Order o:orders){
            o.status = 'Activated';
        }
        update orders;
    }

}