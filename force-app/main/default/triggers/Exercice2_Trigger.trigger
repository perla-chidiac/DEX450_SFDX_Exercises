trigger Exercice2_Trigger on Contact (before insert, before update, before delete, after insert, after update, after delete) {
    new Exercice2TriggerHandler().run();
}
