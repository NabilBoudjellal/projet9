/**
 * le fonctionnement est ok manque juste les commentaires
 */
@isTest
public with sharing class TestDataFactory {
    public static void accountGen(Integer nbrAcocunts,Integer uPrice, Integer itemQte){
        List<Account> actList = new List<Account>();
        
        for(Integer i=0;i<nbrAcocunts;i++){
            actList.add(new Account(Name='Account'+i));
        }
        insert actList;
        List<Contract> activeContract= activeContractGen(actList);
        List<Order> ordersList=orderGen(actList, activeContract);
        PricebookEntry priceList = productGen(uPrice);
        itemOrdersGen(ordersList,priceList,itemQte);
        activateOrders();
    }
    public static List<Contract> activeContractGen(List<Account> actList){
		List<Contract> contractList = new List<Contract>();
        for(Integer i=0;i<actList.size();i++){
        contractList.add(new Contract(AccountId= actList[i].id,
                                         Status='Draft',
                                         StartDate= Date.newInstance(2021, 01, 01),
                                         ContractTerm=2000
                                         ));
        }
        insert contractList;
        for(Contract c: contractList){
            c.Status='Activated';
        }
        update contractList;
        return contractList;
    }
    
    public static PricebookEntry productGen(Integer uPrice){
        
        Product2 prod = new Product2(Name='Product', 
                                      Family='TestFamily', 
                                      isActive=true);
        
        insert prod;
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(),
                                                     Product2Id=prod.Id,
                                                     UnitPrice= uPrice,
                                                     IsActive = true);
        insert pbe1;
        return pbe1;
                                  
    }
    
    public static List<Order> orderGen(List<Account> actList, List<Contract> contractList){
        List<Order> orders = new List<Order>();
        for(Account a: actList){
            orders.add(new Order(Name = a.name+'cmd', 
                                 AccountId= a.id,
                                 Pricebook2Id=Test.getStandardPricebookId(),
                                 EffectiveDate = Date.newInstance(2022, 03, 27),
                                 Status = 'Draft'));
        }
        insert orders;
        
        for(Integer i=0;i<orders.size();i++){
            for(Integer j=0;j<contractList.size();j++){
                if(orders[i].AccountId == contractList[j].AccountId){
                    orders[i].ContractId=contractList[j].id;
                    j=contractList.size();
                }
            }
        }
        update orders;
        return orders;
    }
    public static void itemOrdersGen(List<Order> orders, PricebookEntry pbe2, Integer itemQte){
        
        List<OrderItem> orderItemtest = new List<OrderItem>();
        for(Order o: orders){
                orderItemtest.add(new OrderItem(Product2Id = pbe2.Product2Id,
                                  				OrderId= o.id,
                                  				PricebookEntryId=pbe2.id,
                                  				UnitPrice = pbe2.UnitPrice,
                                  				Quantity=itemQte));
        }
        insert orderItemtest;
    }
        public static void activateOrders(){
		List<Order> odr = [select id, status,TotalAmount from Order limit 100];
        for(Order o: odr){
            o.status = 'Activated';
        }
        update odr;
        
    }
}