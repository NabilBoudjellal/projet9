/**
 * this batch update turnover stands for each account in the org (it takes only activated orders)
 */
public class UpdateAccounts implements Database.Batchable<sObject> {

            public Database.QueryLocator start(Database.BatchableContext info){
                        //Query only orders whit activated status
                        return Database.getQueryLocator('SELECT accountid from order where status=\'Activated\'');
                    }

            public void execute(Database.BatchableContext info, List<Order> scope){      
                //generate a set of id accounts
                Set<Id> setAccountId = new Set<Id>();
                for(Order ord: scope){
                    setAccountId.add(ord.AccountId);
                }
                //calling the method that update turnover stands for each account that (it takes only activated orders)
                UpdateTurnoverStands.UpdateTurnoverStandsMethod(setAccountId);
            }
        public void finish(Database.BatchableContext info){

        }     
}