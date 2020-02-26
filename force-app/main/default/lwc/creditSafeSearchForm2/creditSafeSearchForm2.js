/**
 * Created by jaapbranderhorst on 23/02/2020.
 */

import {api, LightningElement, track} from 'lwc';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';
import {createErrorMessageMarkup} from 'c/companyInfoUtils';

import Country_Belgium from '@salesforce/label/c.Country_Belgium';
import Country_France from '@salesforce/label/c.Country_France';
import Country_Germany from '@salesforce/label/c.Country_Germany';
import Country_Ireland from '@salesforce/label/c.Country_Ireland';
import Country_Netherlands from '@salesforce/label/c.Country_Netherlands';
import Country_United_Kingdom from '@salesforce/label/c.Country_United_Kingdom';
import Country_Sweden from '@salesforce/label/c.Country_Sweden';
import Active from '@salesforce/label/c.Active';
import NonActive from '@salesforce/label/c.NonActive';
import Status from '@salesforce/label/c.Status';
import Search_VAT_Number from '@salesforce/label/c.Search_VAT_Number';
import Registration_Type from '@salesforce/label/c.Registration_Type';
import Registration_Number from '@salesforce/label/c.Registration_Number';
import Creditsafe_company_identifier from '@salesforce/label/c.Creditsafe_company_identifier';
import Search_Street from '@salesforce/label/c.Search_Street';
import Search_City from '@salesforce/label/c.Search_City';
import Province from '@salesforce/label/c.Province';
import Search_Postal_Code from '@salesforce/label/c.Search_Postal_Code';
import Name from '@salesforce/label/c.Name';
import Search_Country from '@salesforce/label/c.Search_Country';
import Ltd from '@salesforce/label/c.Ltd';
import Non_Limited from '@salesforce/label/c.Non_Limited';
import CreditSafe_Validation_Message_Heading from '@salesforce/label/c.CreditSafe_Validation_Message_Heading';
import Search_Criterium_Registration_Number_Description from '@salesforce/label/c.Search_Criterium_Registration_Number_Description';
import Search_Criterium_CreditSafe_Id_Description from '@salesforce/label/c.Search_Criterium_CreditSafe_Id_Description';
import Search_Criterium_Name_Status_Address_Description from '@salesforce/label/c.Search_Criterium_Name_Status_Address_Description';
import Search_Criterium_VAT_Number_Description from '@salesforce/label/c.Search_Criterium_VAT_Number_Description';
import Search_Criterium_Name_Status_Registration_type_Address_Description from '@salesforce/label/c.Search_Criterium_Name_Status_Registration_type_Address_Description';
import Search_Criterium_Name_Status_Address_Province_Description from '@salesforce/label/c.Search_Criterium_Name_Status_Address_Province_Description';
import Validation_Error_Message_Toast_Title from '@salesforce/label/c.Validation_Error_Message_Toast_Title';

export default class CreditSafeSearchForm2 extends LightningElement {

    @api selectedCountry;

    @api name;
    @api status;
    @api creditSafeId;
    @api registrationNumber;
    @api registrationType;
    @api vatNumber;
    @api province;
    @api city;
    @api street;
    @api postalCode;

    @track errorMessage;
    @track errorTitle = Validation_Error_Message_Toast_Title;

    label = {
        Status,
        Search_VAT_Number,
        Registration_Type,
        Registration_Number,
        Creditsafe_company_identifier,
        Search_Street,
        Search_City,
        Province,
        Search_Postal_Code,
        Name,
        Search_Country
    }

    get countries() {
        return [
            { label: Country_Netherlands, value: 'NL'},
            { label: Country_Belgium, value: 'BE' },
            { label: Country_Germany, value: 'DE' },
            { label: Country_France, value: 'FR' },
            { label: Country_United_Kingdom, value: 'GB' },
            { label: Country_Ireland, value: 'IE' },
            { label: Country_Sweden, value: 'SE' }
        ];
    }

    get registrationTypes() {
        return [
            { label: Ltd, value: 'Ltd'},
            { label: Non_Limited, value: 'NonLtd'}
        ]
    }

    get isGbSelected() {
        return this.selectedCountry === 'GB';
    }

    get isBeSelected() {
        return this.selectedCountry === 'BE';
    }

    get isDeSelected() {
        return this.selectedCountry === 'DE';
    }

    get isFrSelected() {
        return this.selectedCountry === 'FR';
    }

    get isSeSelected() {
        return this.selectedCountry === 'SE';
    }

    get isIeSelected() {
        return this.selectedCountry === 'IE';
    }

    get showProvince() {
        return this.isFrSelected;
    }

    get statuses() {
        let statuses;
        if (this.isFrSelected) {
            // TODO: labels
            statuses = [
                { label: Active, value: 'active' },
                { label: NonActive, value: 'nonactive'},
                { label: 'Active, NonActive', value: 'active, NonActive' }
            ];
        }
        if (this.isSeSelected || this.isIeSelected || this.isGbSelected || this.isDeSelected) {
            // TODO: labels
            statuses = [
                { label: Active, value: 'active' },
                { label: 'Active, NonActive', value: 'Active, NonActive' }
            ];
        }
        if (this.isBeSelected) {
            statuses = [
                { label: Active, value: 'active' },
                { label: NonActive, value: 'nonactive' }
            ];
        }
        return statuses;
    }

    get hasErrorMessage() {
        let retValue;
        if (this.errorMessage)
            retValue = true;
        else
            retValue = false;
        return retValue;
    }

    @api
    allValid() {
        this.errorMessage = null;
        let valid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        // format of the fields is checked through the right markup (regex, minlength etc.)
        // so we only need to check if the right fields have been filled
        if (valid) {
            if (this.isNlSelected) {
                if (!this.creditSafeId &&
                    !this.registrationNumber &&
                    !(this.name || this.status || this.street || this.city || this.postalCode )) {
                    this.errorMessage = createErrorMessageMarkup(
                        [Search_Criterium_CreditSafe_Id_Description,
                            Search_Criterium_Registration_Number_Description,
                            Search_Criterium_Name_Status_Address_Description
                        ]);
                }
            }
            if (this.isBeSelected) {
                if (!this.creditSafeId &&
                    !this.registrationNumber &&
                    !this.vatNumber &&
                    !(this.name || this.status || this.street || this.city || this.postalCode )) {
                    this.errorMessage = createErrorMessageMarkup(
                        [Search_Criterium_CreditSafe_Id_Description,
                            Search_Criterium_Registration_Number_Description,
                            Search_Criterium_Name_Status_Address_Description,
                            Search_Criterium_VAT_Number_Description
                        ]);
                }
            }
            if (this.isDeSelected) {
                if (!this.creditSafeId &&
                    !this.registrationNumber &&
                    !this.vatNumber &&
                    !(this.name || this.status || this.street || this.city || this.postalCode || this.registrationType)) {
                    this.errorMessage = createErrorMessageMarkup(
                        [Search_Criterium_CreditSafe_Id_Description,
                            Search_Criterium_Registration_Number_Description,
                            Search_Criterium_Name_Status_Registration_type_Address_Description,
                            Search_Criterium_VAT_Number_Description
                        ]);
                }
            }
            if (this.isFrSelected) {
                if (!this.creditSafeId &&
                    !this.registrationNumber && // postal code and status can be entered/selected as well but are optional so we don't check
                    !this.vatNumber &&
                    !(this.name || this.status || this.street || this.city || this.postalCode || this.province)) { // apparently this is how it should work but you can get a lot of results
                    this.errorMessage = createErrorMessageMarkup(
                        [Search_Criterium_CreditSafe_Id_Description,
                            Search_Criterium_Registration_Number_Description,
                            Search_Criterium_Name_Status_Address_Province_Description,
                            Search_Criterium_VAT_Number_Description
                        ]);
                }
            }
            if (this.isGbSelected || this.isIeSelected) {
                if (!this.creditSafeId &&
                    !this.registrationNumber &&
                    !(this.name || this.status || this.street || this.city || this.postalCode || this.registrationType)) { // apparently this is how it should work but you can get a lot of results
                    this.errorMessage = createErrorMessageMarkup(
                        [Search_Criterium_CreditSafe_Id_Description,
                            Search_Criterium_Registration_Number_Description,
                            Search_Criterium_Name_Status_Registration_type_Address_Description
                        ]);
                }
            }
            if (this.isSeSelected) {
                if (!this.registrationNumber &&
                    !(this.name || this.status || this.street || this.city || this.postalCode || this.registrationType)) { // apparently this is how it should work but you can get a lot of results
                    this.errorMessage = createErrorMessageMarkup(
                        [Search_Criterium_Registration_Number_Description,
                            Search_Criterium_Name_Status_Registration_type_Address_Description
                        ]);
                }
            }
            if (this.errorMessage) {
                this.template.querySelector('.error-message').showToast();
            }
        }
        // if the errorMessage is set, this will return false
        valid = valid && !this.errorMessage;
        return valid;
    }

    handleOnChange(event) {
        const attributeChangeEvent = new FlowAttributeChangeEvent(event.target.name, event.target.value);
        this.dispatchEvent(attributeChangeEvent);
    }

    handleSelectedCountryChange(event) {
        this.selectedCountry = event.target.value;
        this.handleOnChange(event);
    }

    handleStatusOnChange(event) {
        this.status = event.target.value;
        this.handleOnChange(event);
    }

    handleRegistrationTypeOnChange(event) {
        this.registrationType = event.target.value;
        this.handleOnChange(event);
    }

}