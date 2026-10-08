import { LightningElement, api } from 'lwc';

export default class CounterChildComponent extends LightningElement {
    @api counter = 0;
}