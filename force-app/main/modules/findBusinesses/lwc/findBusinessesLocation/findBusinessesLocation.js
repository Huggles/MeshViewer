/**
 * Created by Hugo on 20/08/2020.
 */

import {api, LightningElement, track} from 'lwc';
import {loadScript, loadStyle} from "lightning/platformResourceLoader";
import leaflet from '@salesforce/resourceUrl/leaflet';
import GeoJSONProvinces from '@salesforce/resourceUrl/GeoJSON';
import postalCodesData from '@salesforce/resourceUrl/PostalCodes';

import Select_All from '@salesforce/label/c.Select_All'
import Remove_All from '@salesforce/label/c.Remove_All'

export default class FindBusinessesLocation extends LightningElement {

    /*
     * The labels used in this screen
     */
    labels = {
        Select_All,
        Remove_All
    }

    /*
     * All map layers
     */
    MAP_LAYERS = {
        PROVINCE : 'PROVINCE',
        POSTALCODE : 'POSTALCODE'
    }

    /*
     * Styles to present the map
     */
    selectedStyle = {
        opacity : 0.5,
        color : '#a09f9f',
        fillColor : 'green',
        fillOpacity : 0.8,
        radius: 300,
        weight : 1,
    }
    deselectedStyle = {
        opacity : 0.2,
        color : '#a09f9f',
        fillColor : 'red',
        fillOpacity : 0.5,
        radius: 250,
        weight : 1,
    }

    /*
     * Sets the selected layer to present.
     */
    _selectedMapLayer = this.MAP_LAYERS.POSTALCODE;
    get selectedMapLayer(){
        return this._selectedMapLayer;
    }
    set selectedMapLayer(value){
        this._selectedMapLayer = value;
    }

    @api selectedLocations = {}

    @api getLocationArray(){
        if(this.selectedMapLayer === this.MAP_LAYERS.PROVINCE ) return this.getSelectedProvinces();
        if(this.selectedMapLayer === this.MAP_LAYERS.POSTALCODE ) return this.getSelectedPostalCodes();
    }
    getSelectedProvinces(){
        let selectedProvinces = [];
        for (const [key, value] of Object.entries(this.provinces)) {
            if(value.selected === true) selectedProvinces.push(key);
        }
        let response = {
            locations : selectedProvinces,
            type : this.MAP_LAYERS.PROVINCE
        }
        return response;
    }
    getSelectedPostalCodes(){
        let selectedPostalCodes = [];
        for (const [key, value] of Object.entries(this.postalCodes)) {
            if(value.selected === true) selectedPostalCodes.push(value.Code.toString());
        }
        let response = {
            locations : selectedPostalCodes,
            type : this.MAP_LAYERS.POSTALCODE
        }
        return response;
    }

    /*
     * Leaflet Properties
     */
    _leafletMap;
    _leafletMapHTMLElement;
    _leafletLibraryLoaded = false;
    _leafletMapLoaded = false;
    _openStreetMapTileLayer;

    loadingMap = false;

    connectedCallback() {
        this.loadingMap = true;
        this.loadLeaflet();
    }
    renderedCallback() {
        this._leafletMapHTMLElement = this.template.querySelector("[data-identifier='leafletMap']");
        if(this._leafletMapHTMLElement  != null){
            this.initLeafletMap();
        }
    }




    /*
     * General Functions
     */
    loadLeaflet(){
        Promise.all([
            loadScript(this, leaflet + '/leaflet.js'),
            loadStyle(this, leaflet + '/leaflet.css'),
            this.loadGeoJSON()
        ]).then((result)=>{
            this._leafletLibraryLoaded = true;
            this.initLeafletMap();
        })
    }
    async loadGeoJSON(){
        this.loadGeoJSONProvinces();
        this.loadGeoJSONPostalCodes();
        Promise.resolve();
    }
    loadGeoJSONProvinces(){
        let request = new XMLHttpRequest();
        request.open("GET", GeoJSONProvinces, false);
        request.send(null);
        this.provincesData = JSON.parse(request.responseText)[0];
    }
    loadGeoJSONPostalCodes(){
        let request = new XMLHttpRequest();
        request.open("GET", postalCodesData, false);
        request.send(null);
        this.postalCodesData = JSON.parse(request.responseText);
    }
    initLeafletMap(){
        if(this._leafletMapHTMLElement != null && this._leafletLibraryLoaded == true && this._leafletMapLoaded == false){
            this._leafletMapLoaded = true;
            this._leafletMap = L.map(this._leafletMapHTMLElement, {
                zoomDelta: 0.25,
                zoomSnap: 0.25,
                preferCanvas: true,
            }).setView([52.2044968, 5.6275306], 6.5);
            this._openStreetMapTileLayer = L.tileLayer(
                'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                {
                    maxZoom: 12,
                    minZoom: 6.5,
                })
                .addTo(this._leafletMap);
            try{
                this.initProvinces();
                this.initPostalCodes();

            }catch (e) {
                console.log(e);
            }
            this.loadingMap = false;
        }
    }

    /*
    * Handle the click on a tab
    */
    handleTabClick(event){
        let tabValue = event.target.value;
        this.selectedMapLayer = tabValue;
        if(this._leafletMap != null){
            this.showLayer(tabValue);
        }
    }
    showLayer(layerName){
        if (layerName == this.MAP_LAYERS.PROVINCE){
            this._leafletMap.removeLayer(this.postalCodesLayer);
            this.provincesLayer.addTo(this._leafletMap);
        }
        if (layerName == this.MAP_LAYERS.POSTALCODE){
            this._leafletMap.removeLayer(this.provincesLayer);
            this.postalCodesLayer.addTo(this._leafletMap);
        }
    }


    /*
     * Province Functions
     */

    /*
     * Province data
     */
    provincesData;
    provincesLayer;
    @track provinces = {};

    initProvinces(){
        if(this.provincesLayer == null){
            let payload = {
                onEachFeature: ((feature, layer) =>{
                    let featureData = {};
                    featureData['properties'] = feature.properties;
                    featureData['layerElement'] = layer;
                    featureData['id'] = feature.properties.name;
                    featureData['name'] = feature.properties.name;
                    featureData['selected'] = false;
                    layer.setStyle(this.deselectedStyle);
                    layer.on('click', (event)=>{
                        this.provinceFeatureClicked(featureData.id,this);
                    });
                    this.provinces[feature.properties.name] = featureData;
                })
            };
            this.provincesLayer = L.geoJSON(this.provincesData,payload);
        }
    }

    provinceSelectionChanged(event) {
        let provinceId = event.currentTarget.dataset['id'];
        this.provinceFeatureClicked(provinceId, this);
    }
    provinceFeatureClicked(province_id, controller){
        let provinceData = controller.provinces[province_id];
        let selected = provinceData.selected;
        try {
            if(!selected){
                controller.provinces[province_id].selected = true;
                provinceData.layerElement.setStyle(this.selectedStyle);
            }else{
                controller.provinces[province_id].selected = false;
                provinceData.layerElement.setStyle(this.deselectedStyle);
            }
        }catch (e){
            console.log(e);
        }

    }

    /*
   * Turn the map into an array so it can be shown as a list in HTML.
   */
    get provincesArray(){
        let returnArray = [];
        for(const [key, value] of Object.entries(this.provinces)){
            returnArray.push(value);
        }
        return returnArray;
    }

    /*
     * Postal Code Functions
     */

    /*
     * Postal Code
     */
    postalCodesData;
    postalCodesLayer;
    postalCodesDataLoaded = false;
    @track postalCodes = {};

    initPostalCodes(){
        if(this.postalCodesDataLoaded == false){
            this.postalCodesDataLoaded = true;
            this.postalCodesLayer = L.layerGroup().addTo(this._leafletMap);
            let controller = this;
            this.postalCodesData.forEach((item, index)=>{
                let postalCodeCircle = L.circle([item.Lat, item.Lon], this.deselectedStyle);
                postalCodeCircle.on("click", (feature, layer)=>{
                    let postalCodeId = item.id;
                    if(!controller.postalCodes[postalCodeId].selected){
                        controller.selectPostalCode(postalCodeId);
                    }else{
                        controller.deselectPostalCode(postalCodeId);
                    }
                });
                item['layerElement'] = postalCodeCircle;
                item['selected'] = false;
                item['label'] = item.Code + ' - ' + item.City;
                item['id'] = item.Code + '-' + item.City;
                this.postalCodes[item.id] = item;
                this.postalCodesLayer.addLayer(postalCodeCircle);
            });
        }


    }

    @track postalCodeSearchMatches = [];
    onPostalCodeSearchInputChange(){
        this.findMatchingPostalCodes();
    }
    async findMatchingPostalCodes(){
        let matchArray = [];
        let searchString = this.template.querySelector('[data-identifier="PostalCodeSearchInput"]').value;
        if(searchString.length > 1){
            for (const [key, value] of Object.entries(this.postalCodes)) {
                if(!value.selected && (value.Code.toString().startsWith(searchString) || value.City.includes(searchString))){
                    matchArray.push(value);
                }
            }
        }
        this.postalCodeSearchMatches = matchArray;
    }

    onPostalCodeSearchMatchClick(event){
        let postalCode = event.currentTarget.dataset['id'].toString();
        this.selectPostalCode(postalCode);
    }
    selectPostalCode(id){
        this.postalCodes[id].selected = true;
        this.postalCodes[id].layerElement.setStyle(this.selectedStyle);
        this.postalCodes[id].layerElement.setRadius(this.selectedStyle.radius);
        this.findMatchingPostalCodes();
    }
    deselectPostalCode(id){
        this.postalCodes[id].selected = false;
        this.postalCodes[id].layerElement.setStyle(this.deselectedStyle);
        this.postalCodes[id].layerElement.setRadius(this.deselectedStyle.radius);
        this.findMatchingPostalCodes();
    }
    onSelectedPostalCodeRemove(event){
        let id = event.currentTarget.dataset['id'];
        this.deselectPostalCode(id);
    }
    onPostalCodeSelectAllClick(event){
        this.postalCodeSearchMatches.forEach((item, index)=>{
            this.selectPostalCode(item.id);
        });
        this.findMatchingPostalCodes();
    }
    onRemoveAllSelectedPostalCodes(event){
        for (const [key, value] of Object.entries(this.postalCodes)) {
            if(value.selected){
                this.deselectPostalCode(value.id);
            }
        }
    }
    get selectedPostalCodes(){
        let returnArray = [];
        for (const [key, value] of Object.entries(this.postalCodes)) {
            if(value.selected){
                returnArray.push(value);
            }
        };
        return returnArray;
    }

    _searchInputHasFocus = false;
    onSearchInputFocus(event){
        this._searchInputHasFocus = true;
    }
    onSearchInputBlur(event){
        this._searchInputHasFocus = false;
    }
    get showMatches(){
        if(this.postalCodeSearchMatches != null && this.postalCodeSearchMatches.length > 0 && this._searchInputHasFocus){
            return true;
        }
        return false;
    }
    get hasSelectedPostalCodes(){
        if(this.selectedPostalCodes.length > 0) return true;
        return false;
    }

}