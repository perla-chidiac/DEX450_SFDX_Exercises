import { LightningElement, track } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

import getAccountOpportunity from '@salesforce/apex/AccountOpportunityController.getAccountOpportunity';
import updateOpportunityStage from '@salesforce/apex/AccountOpportunityController.updateOpportunityStage';

export default class AccountOpportunityController extends LightningElement {
    @track wrapperData;
    isModelOpen = false;
    selectedOpportunityId;
    selectedStage = '';

    stageOptions = [
        {label: 'Closed Won', value: 'Closed Won'},
        {label: 'Closed Lost', value: 'Closed Lost'}
    ];

    connectedCallback(){
        this.loadData();
    }

    loadData(){
        getAccountOpportunity()
            .then(result => {
                this.wrapperData = result;
            })
            .catch(error => {
                let message = 'Unknown error';
                if (error && error.body && error.body.message) {
                    message = error.body.message;
                } else if (error && error.message) {
                    message = error.message;
                }
                this.showToast('Error', message, 'error');
            });
    }

    handleMarkAsClosed(event){
        this.selectedOpportunityId = event.target.dataset.id;
        this.isModelOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
        this.selectedOpportunityId = null;
        this.selectedStage = '';
    }

    handleStageChange(event) {
        this.selectedStage = event.detail.value;
    }

    handleUpdateOpportunity() {
        if (!this.selectedStage) {
            this.showToast('Warning', 'Please select a closing stage status.', 'warning');
            return;
        }

        updateOpportunityStage({ 
            opportunityId: this.selectedOpportunityId, 
            newStage: this.selectedStage 
        })
        .then(() => {
            this.showToast('Success', 'Opportunity updated successfully.', 'success');
            this.closeModal();
            return this.loadData(); 
        })
        .catch(error => {
            let message = 'Unknown error';
            if (error && error.body && error.body.message) {
                message = error.body.message;
            } else if (error && error.message) {
                message = error.message;
            }
            this.showToast('Error', message, 'error');
        });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}