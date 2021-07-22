public class UpdateAccounts implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext info){
                //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
                return Database.getQueryLocator('SELECT accountid from order where status=\'Activated\' group by accountid');
            }
            public void execute(Database.BatchableContext info, List<Order> scope){      
                Set<Id> setAccountId = new Set<Id>();
                for(Order ord: scope){
                    setAccountId.add(ord.AccountId);
                }
                List<Account> accountActiveOrders = [select id from account where id in:setAccountId];
                list<Order> listOrders =  [SELECT Id, TotalAmount, AccountId FROM Order where AccountId in:setAccountId];

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
        public void finish(Database.BatchableContext info){

        }     
}