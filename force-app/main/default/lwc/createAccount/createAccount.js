import { LightningElement, wire } from 'lwc';
import createAccount from '@salesforce/apex/AccountController.createAccount';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import { refreshApex } from '@salesforce/apex';

export default class CreateAccount extends LightningElement {
    accountName = '';
    maxRecords = 10;
    accounts;
    errors;
    
    // Track the entire wire response object to feed into refreshApex later
    wiredAccountsResult;

    @wire(getAccounts, { maxRecords: '$maxRecords' }) 
    wired_getAccounts(result) {
        this.wiredAccountsResult = result; 
        const { data, error } = result;

        if (data) {
            this.accounts = data;
            this.errors = undefined;
        } else if (error) {
            this.errors = error;
            this.accounts = undefined;
        }
    }

    // Let user choose max records to display
    handleMaxRecordsChange(event) {
        this.maxRecords = parseInt(event.target.value, 10) || 0;
    }
    
    // Handles the Account Name input field
    handleAccountNameChange(event) {
        this.accountName = event.target.value;
    }

    // Imperative callback to create account
    handleCreateAccount() {
        if (!this.accountName) {
            console.error('Account Name cannot be empty');
            return;
        }
        createAccount({ accountName: this.accountName })
            .then(result => {
                console.log('Account created successfully: ', JSON.stringify(result));
                this.accountName = ''; 
                
                // Refresh the accounts list after creating a new account
                return refreshApex(this.wiredAccountsResult);
            })
            .catch(error => {
                console.error('Error creating account: ', error);
                this.errors = error;
            });
    }   

}
