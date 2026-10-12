import { LightningElement, api, wire } from 'lwc';
import {deleteRecord} from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import getContactsByAccountId from '@salesforce/apex/AccountContactsController.getContactsByAccountId';
import ContactCreateModal from 'c/contactCreateModal';

export default class AccountContactsComponent extends LightningElement {
    @api recordId;

    contacts;
    errors;
    
    wiredContactsResult;

    @api async invoke(){
        await ContactListModal.open({
            size: 'medium',
            accountId: this.recordId
        })
    }

    @wire(getContactsByAccountId, { accountId: '$recordId', maxRecords: 100 }) wired_getContacts(result) {
        this.wiredContactsResult = result;
        const {data, error} = result;

        if (data){
            this.contacts = data;
            this.error = undefined;
        } else if (error){
            this.errors = error;
            this.contacts = undefined;
        }
    }

    handleRowAction(event){
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if (actionName === 'delete'){
            this.handleDeleteContact(row.Id);
        }
    }

    handleDeleteContact(event){
        const contactId = event.target.value;
        deleteRecord(contactId)
            .then(() => {
                this.contacts = this.contacts.filter(contact => contact.Id !== contactId);
            })
            .catch(error => {
                console.error('Error deleting contact:', error);
            });
    }

    async openCreateModal() {
        const result = await ContactCreateModal.open({
            size: 'small',
            accountId: this.recordId 
        });

        // If contactCreateModal returns true on hide, refresh our list
        if (result) {
            await refreshApex(this.wiredContactsResult);
        }
    }
}