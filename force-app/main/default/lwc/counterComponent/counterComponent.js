import { LightningElement } from 'lwc';

export default class CounterComponent extends LightningElement {
    count = 0;

    handleChildIncrementation(){
        this.count++;
    
    }
}