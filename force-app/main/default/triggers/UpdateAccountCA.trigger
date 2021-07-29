/**
 * this trigger update the turnover stands after each order update
 */
trigger UpdateAccountCA on Order (after update) {

    List<Order> updatedOrders = [select AccountId from Order where id IN :Trigger.new];

    Set<Id> accountIdsToUpdate = new Set<Id>();
    for(Order o: updatedOrders){
        accountIdsToUpdate.add(o.AccountId);
    }
    UpdateTurnoverStands.UpdateTurnoverStandsMethod(accountIdsToUpdate);
}
