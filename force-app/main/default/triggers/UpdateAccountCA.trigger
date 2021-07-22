/**
 * this trigger update the turnover stands after each order update
 */
trigger UpdateAccountCA on Order (after update) {

    List<Order> updatedOrders = [select AccountId from Order where id IN :Trigger.new];

    Set<Id> accountIdsToUpdate = new Set<Id>();
    for(Order o: updatedOrders){
        accountIdsToUpdate.add(o.AccountId);
    }
    List<Order> ordersNeeded_ToCalculte_TurnoverStand = [Select AccountId, TotalAmount from Order where AccountId IN : accountIdsToUpdate];
    List<Account> accountToUpdate = [Select Id, Chiffre_d_affaire__c from Account where Id IN : accountIdsToUpdate];
    Decimal i;
    for(Account a: accountToUpdate){
        i = 0;
        for(Order odr: ordersNeeded_ToCalculte_TurnoverStand){
            if(a.Id == odr.AccountId)
            i = i + odr.TotalAmount;
        }
        a.Chiffre_d_affaire__c = i;
    }
    update accountToUpdate;
}
/**
 * ca que j'ai fait :
 * -- création du champs Chiffre_d_affaire__c, du fait qu'il n'existait pas au départ
 * -- ajout d'un commentaire pour expliquer le fonctionnement du trigger
 * -- modification de la structure du trigger pour ne pas faire de requette SOQL à l'interieur d'une boucle (best practice)
 * -- pour optimiser le code pour qu'il s'applique a plus d'un update si c'est le cas
 * -- la mise a jour de tous les chiffre d'affaire pour les comptes avec une commande de modifier
 */