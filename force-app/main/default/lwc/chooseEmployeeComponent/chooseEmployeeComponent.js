import { LightningElement, track } from 'lwc';

export default class ChooseEmployeeComponent extends LightningElement {
    employees = [
        {
            id: 1,
            name: 'John Smith',
            department: 'IT', 
            position: 'Developer'
        },
        {
            id: 2,
            name: 'Sarah Johnson',
            department: 'HR',
            position: 'Recruiter'
        },
        {
            id: 3,
            name: 'Mike Brown',
            department: 'IT',
            position: 'QA Engineer'
        },
        {
            id: 4,
            name: 'Emma Davis',
            department: 'Finance',
            position: 'Accountant'
        },
        {
            id: 5,
            name: 'Chris Wilson',
            department: 'HR',
            position: 'HR Manager'
        }
    ];

    // reactive properties
    chosenDepartment = "";
    @track filteredEmployees = [];
    @track selectedEmployee = null;

    // dropdown options 
    get departmentOptions(){
        return [
            { label: 'IT', value: 'IT' }, 
            { label: 'HR', value: 'HR' },
            { label: 'Finance', value: 'Finance' }
        ];
    }

    // handle department change
    handleDepartmentChange(event){
        this.chosenDepartment = event.detail.value;

        this.selectedEmployee = null; 
    
        this.filteredEmployees = this.employees.filter(
            emp => emp.department === this.chosenDepartment
        );
    }

    // Employee click logic to show details
    handleEmployeeClick(event) {
        // Extract the unique ID from the data-id attribute
        const empId = event.currentTarget.dataset.id;
        
        this.selectedEmployee = this.employees.find(emp => emp.id === Number(empId));
    }
}