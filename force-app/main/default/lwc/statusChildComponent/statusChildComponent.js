import { LightningElement, api } from 'lwc';

export default class StatusChildComponent extends LightningElement {
    isSelected = false;
  
    get status(){
        return this.isSelected ? 'Selected' : 'Deselected';
    }

    get buttonLabel(){
        return this.isSelected ? 'Deselect' : 'Select';
    }

    get buttonVariant(){
        return !this.isSelected ? 'brand' : 'neutral';
    }

    handleButton(){
        this.isSelected = !this.isSelected;

        // dispatches event upward
        const toggleEvent = new CustomEvent('statuschange', {
            detail: {isSelected: this.isSelected},
            bubbles: true,
            composed: true
        });
        
        this.dispatchEvent(toggleEvent);
    }

    @api 
    reset(){
        this.isSelected = false;
    }
}