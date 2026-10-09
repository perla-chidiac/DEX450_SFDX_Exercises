import { LightningElement } from 'lwc';

export default class StatusComponent extends LightningElement {
    child1Status = 'Deselected';
    child2Status = 'Deselected';

    handleStatusChange(event) {
        const isSelected = event.detail.isSelected;
        const statusText = isSelected ? 'Selected' : 'Deselected';
        
        // Read the data-id attribute from the component that fired the event
        const childId = event.target.dataset.id;

        if (childId === 'child1') {
            this.child1Status = statusText;
        } else if (childId === 'child2') {
            this.child2Status = statusText;
        }
    }

    // handleResetAll() {
    //     const children = this.template.querySelectorAll('c-status-child-component');
        
    //     if (children) {
    //         children.forEach(child => {
    //             child.reset();
    //         });
    //     }

    //     // Reset parent tracking state back to default values
    //     this.child1Status = 'Deselected';
    //     this.child2Status = 'Deselected';
    // }
}
