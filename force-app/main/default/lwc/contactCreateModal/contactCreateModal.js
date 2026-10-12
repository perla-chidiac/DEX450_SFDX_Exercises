import { LightningElement, api } from 'lwc';
import LightningModal from 'lightning/modal';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ContactCreateModal extends LightningModal {
    @api accountId; 

    handleCancel() {
        this.close(false); 
    }

    handleSuccess(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Contact created successfully!',
                variant: 'success'
            })
        );
        this.close(true); 
    }

    handleError(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error creating contact',
                message: event.detail.detail,
                variant: 'error'
            })
        );
    }
}