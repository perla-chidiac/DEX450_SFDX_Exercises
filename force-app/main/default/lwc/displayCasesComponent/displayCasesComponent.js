import { LightningElement, wire, track } from 'lwc';
import {getPicklistValues} from 'lightning/uiObjectInfoApi';
import getCases from '@salesforce/apex/CaseController.getCases';
import createCase from '@salesforce/apex/CaseController.createCase';
import STATUS_FIELD from '@salesforce/schema/Case.Status';

export default class DisplayCasesComponent extends LightningElement {
    @track caseNumber='';
    @track selectedStatus='';

    caseSubject = '';
    caseDescription = '';
    maxRecords = 100;
    cases;
    errors;

    columns = [
        { label: 'Case Number', fieldName: 'CaseNumber' },
        { label: 'Subject', fieldName: 'Subject' },
        { label: 'Description', fieldName: 'Description' },
        { label: 'Status', fieldName: 'Status' }
    ];

    // create case record
    handleCaseSubjectChange(event){
        this.caseSubject = event.target.value;
    }

    handleCaseDescriptionChange(event){
        this.caseDescription = event.target.value;
    }

    handleCreateCase(){
        if(!this.caseSubject || !this.caseDescription){
            console.error('Case Subject and Description cannot be empty');
            return;
        }
        createCase({ caseSubject: this.caseSubject, caseDescription: this.caseDescription})
            .then(result => {
                console.log('Case created successfully: ', JSON.stringify(result));
                this.caseSubject = '';
                this.caseDescription = '';
            })
            .catch(error => {
                console.error('Error creating case: ', error);
                this.errors = error;
            });
    }

    handleSearch(event){
        this.caseNumber = event.target.value;
    }

    @wire(getCases, { maxRecords: '$maxRecords', caseNumber:'$caseNumber', status: '$selectedStatus' }) wired_getCases(result){
        const {data, error} = result;

        if(data){
            this.cases = data;
            this.errors = undefined;
        } else if (error){
            this.errors = error;
            this.cases = undefined;
        }
    }
    
    
    // let user filter by status
    @wire(getPicklistValues, { recordTypeId: "012000000000000AAA", fieldApiName: STATUS_FIELD }) 
    statusPicklistValues;

    handleStatusChange(event){
        this.selectedStatus = event.target.value; 
    }

    get statusOptions() {
        return this.statusPicklistValues && this.statusPicklistValues.data 
            ? this.statusPicklistValues.data.values 
            : [];
    }


}