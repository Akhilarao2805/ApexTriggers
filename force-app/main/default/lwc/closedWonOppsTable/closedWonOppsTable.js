import { LightningElement, wire, track } from 'lwc';
import getClosedWonOpps from '@salesforce/apex/ClosedWonOpportunitiesController.getClosedWonOpps';
import { NavigationMixin } from 'lightning/navigation';

const ROW_ACTIONS = [
    { label: 'View', name: 'view' },
    { label: 'Edit', name: 'edit' }
];

export default class ClosedWonOppsTable extends NavigationMixin(LightningElement) {
    @track data;
    @track error;
    @track isLoading = true;

    limitSize = 200;
    sortBy = 'CloseDate';
    sortDirection = 'DESC';

    columns = [
        {
            label: 'Opportunity Name',
            fieldName: 'name',
            type: 'text',
            sortable: true,
            cellAttributes: { class: 'slds-truncate' }
        },
        { label: 'Amount', fieldName: 'amount', type: 'currency', sortable: true },
        { label: 'Close Date', fieldName: 'closeDate', type: 'date', sortable: true },
        { label: 'Stage', fieldName: 'stageName', type: 'text', sortable: true },
        { label: 'Account Name', fieldName: 'accountName', type: 'text' },
        { label: 'Owner', fieldName: 'ownerName', type: 'text' },
        { type: 'action', typeAttributes: { rowActions: ROW_ACTIONS, menuAlignment: 'left' } }
    ];

    @wire(getClosedWonOpps, { limitSize: '$limitSize', sortBy: '$sortBy', sortDirection: '$sortDirection' })
    wiredOpps({ data, error }) {
        if (data) {
            this.data = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
        this.isLoading = false;
    }

    get hasDataOrError() {
        return (this.data && this.data.length > 0) || this.error;
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'view':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.id,
                        objectApiName: 'Opportunity',
                        actionName: 'view'
                    }
                });
                break;
            case 'edit':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.id,
                        objectApiName: 'Opportunity',
                        actionName: 'edit'
                    }
                });
                break;
            default:
        }
    }

    // Optional click handlers if we later render links; for now, using row actions + standard navigation
    navigateToAccount(event) {
        const accountId = event.detail?.value;
        if (!accountId) return;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: accountId,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }
}
