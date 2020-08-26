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

    MAP_LAYERS = {
        PROVINCES : 'PROVINCES',
        POSTALCODE : 'POSTALCODE'
    }

    labels = {
        Select_All,
        Remove_All
    }

    /*
    * The mutable province data determining how the features should be shown on the map.
    */

    @track _provinces = {
        'Drenthe': {
            show_on_map: false
        },
        'Flevoland': {
            show_on_map: false
        },
        'Friesland': {
            show_on_map: false
        },
        'Gelderland': {
            show_on_map: false
        },
        'Groningen': {
            show_on_map: false
        },
        'Limburg': {
            show_on_map: false
        },
        'Noord-Brabant': {
            show_on_map: false
        },
        'Noord-Holland': {
            show_on_map: false
        },
        'Overijssel': {
            show_on_map: false
        },
        'Utrecht': {
            show_on_map: false
        },
        'Zeeland': {
            show_on_map: false
        },
        'Zuid-Holland': {
            show_on_map: false
        }
    }

    @api selectedProvinces = {}

    @api getLocationArray(){
        let selectedProvinces = [];
        for (const [key, value] of Object.entries(this._provinces)) {
            if(value.show_on_map === true) selectedProvinces.push(key);
        }
        return selectedProvinces;
    }




    /*
     * Turn the map into an array so it can be shown as a list in HTML.
     */
    get provincesArray(){
        let returnArray = [];
        for(const [key, value] of Object.entries(this._provinces)){
            returnArray.push({
                name : key,
                show_on_map : value.show_on_map
            })
        }
        return returnArray;
    }

    selectedStyle = {
        opacity : 1,
        color : 'green',
        fillColor : 'green',
        fillOpacity : 1,
        radius: 300,
        weight : 1,
    }
    deselectedStyle = {
        opacity : 0.2,
        color : 'red',
        fillColor : 'red',
        fillOpacity : 0.5,
        radius: 250,
        weight : 1,
    }
    get selectedPostalCodeStyle(){
        let selectedStyle = JSON.parse(JSON.stringify(this.selectedStyle));
        //selectedStyle['radius'] = 500;
        //console.log(selectedStyle);
        return selectedStyle;
    }
    get deselectedPostalCodeStyle(){
        let deselectedStyle = JSON.parse(JSON.stringify(this.deselectedStyle));
        //deselectedStyle['radius'] = 500;
        //console.log(deselectedStyle);
        return deselectedStyle;
    }


    _leafletMap;
    _leafletMapHTMLElement;
    _leafletLibraryLoaded = false;
    _leafletMapLoaded = false;

    _openStreetMapTileLayer;

    _geoJSONProvinces;
    _geoJSONProvincesLayer;

    postalCodesData;
    @track postalCodes = {};

    connectedCallback() {
        this.loadInitialData();
        this.loadLeaflet();
    }
    loadInitialData(){
        if(this.selectedProvinces != null && Object.entries(this.selectedProvinces).length > 0){
            this.selectedProvinces.forEach((selectedProvince)=>{
                this._provinces[selectedProvince].show_on_map = true;
            });
        }
    }
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
        this._geoJSONProvinces = JSON.parse(request.responseText)[0];
    }
    loadGeoJSONPostalCodes(){
        let request = new XMLHttpRequest();
        request.open("GET", postalCodesData, false);
        request.send(null);
        this.postalCodesData = JSON.parse(request.responseText);
    }

    renderedCallback() {
        this._leafletMapHTMLElement = this.template.querySelector("[data-identifier='leafletMap']");
        if(this._leafletMapHTMLElement  != null){
            this.initLeafletMap();
        }

    }

    initLeafletMap(){
        if(this._leafletMapHTMLElement != null && this._leafletLibraryLoaded == true && this._leafletMapLoaded == false){
            this._leafletMapLoaded = true;
            this._leafletMap = L.map(this._leafletMapHTMLElement, {
                zoomDelta: 0.25,
                zoomSnap: 0.25,

            }).setView([52.2044968, 5.6275306], 6.5);
            this._openStreetMapTileLayer = L.tileLayer(
                'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                {
                    maxZoom: 12,
                    minZoom: 6.5,
                })
                .addTo(this._leafletMap);
            try{
                this.initProvincesGeoJSON();
                this.initPostalCodes();

            }catch (e) {
                console.log(e);
            }
            //this.showProvinces();
            this.showAllPostalCodes();


        }
    }

    initProvincesGeoJSON(){
        if(this._geoJSONProvincesLayer == null){
            this._geoJSONProvincesLayer = L.geoJSON(this._geoJSONProvinces,{
                onEachFeature: ((feature, layer) =>{
                    layer.setStyle(this._provinces[feature.properties.name].show_on_map ? this.selectedStyle : this.deselectedStyle);
                    layer.on('click', (event)=>{
                        this.provinceFeatureClicked(feature,layer,this);
                    });
                })
            });
        }
    }
    initPostalCodes(){
        let controller = this;
        this.postalCodesData.forEach((item, index)=>{
            let postalCodeCircle = L.circle([item.Lat, item.Lon], this.deselectedPostalCodeStyle);
            postalCodeCircle.on("click", (feature, layer)=>{
                console.log('clicked');
                let postalCode = item.Code.toString();
                console.log(postalCode);
                console.log(controller.postalCodes[postalCode].selected);
                if(!controller.postalCodes[postalCode].selected){
                    controller.selectPostalCode(postalCode);
                }else{
                    controller.deselectPostalCode(postalCode);
                }
            });
            item['layerElement'] = postalCodeCircle;
            item['selected'] = false;
            item['label'] = item.Code + ' - ' + item.City;
            this.postalCodes[item.Code] = item;
        });

    }
    showLayer(layerName){
        if(layerName === this.MAP_LAYERS.PROVINCES) this.showProvinces();
        if(layerName === this.MAP_LAYERS.POSTALCODE) this.showAllPostalCodes();
    }
    showProvinces(){
        this.hideAllPostalCodes();
        this._geoJSONProvincesLayer.addTo(this._leafletMap);
        this._leafletMap.setMaxBounds(this._geoJSONProvincesLayer.getBounds());
    }
    showAllPostalCodes(){
        this._leafletMap.removeLayer(this._geoJSONProvincesLayer);
        for (const [key, value] of Object.entries(this.postalCodes)) {
            if(value.selected){
                value.layerElement.setStyle(this.selectedPostalCodeStyle);
            }else{
                value.layerElement.setStyle(this.deselectedPostalCodeStyle);
            }
            value.layerElement.addTo(this._leafletMap);
        }
    }
    hideAllPostalCodes(){
        for (const [key, value] of Object.entries(this._provinces)) {
            if(value.selected) {
                this._leafletMap.removeLayer(value.layerElement);
            }
        }
    }
    getProvinceFeatureLayer(provinceName){
        let foundLayer = null;
        this._geoJSONProvincesLayer.eachLayer((layer) => {
            if (layer.feature.properties.name == provinceName) {
                foundLayer = layer;
            }
        });
        return foundLayer;
    }
    provinceFeatureClicked(feature, layer, controller){
        let show_on_map = controller._provinces[feature.properties.name].show_on_map;
        try{
            if(!show_on_map){
                controller.showFeature(feature, layer, controller);
            }else{
                controller.hideFeature(feature, layer, controller)
            }
        }catch (e){
            console.log(e);
        }
    }
    postalCodeFeatureClicked(feature, layer, controller){

    }
    showFeature(feature, layer, controller){
        controller._provinces[feature.properties.name].show_on_map = true;
        layer.setStyle(this.selectedStyle);
    }
    hideFeature(feature, layer, controller){
        controller._provinces[feature.properties.name].show_on_map = false;
        layer.setStyle(this.deselectedStyle);
    }

    provinceSelectionChanged(event) {
        try{
            let provinceLayer = this.getProvinceFeatureLayer(event.target.name);
            this.provinceFeatureClicked(provinceLayer.feature, provinceLayer, this);
        }catch (e){
            console.log(e);
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
        let postalCode = event.currentTarget.dataset['postalcode'].toString();
        this.selectPostalCode(postalCode);
    }
    selectPostalCode(postalCode){
        this.postalCodes[postalCode].selected = true;
        this.postalCodes[postalCode].layerElement.setStyle(this.selectedPostalCodeStyle);
        this.postalCodes[postalCode].layerElement.setRadius(this.selectedPostalCodeStyle.radius);
        this.findMatchingPostalCodes();
    }
    deselectPostalCode(postalCode){
        console.log('deselectPostalCode');
        this.postalCodes[postalCode].selected = false;
        this.postalCodes[postalCode].layerElement.setStyle(this.deselectedPostalCodeStyle);
        this.postalCodes[postalCode].layerElement.setRadius(this.deselectedPostalCodeStyle.radius);
        this.findMatchingPostalCodes();
    }
    onSelectedPostalCodeRemove(event){
        let postalCode = event.currentTarget.dataset['postalcode'].toString();
        this.deselectPostalCode(postalCode);
    }
    onPostalCodeSelectAllClick(event){
        this.postalCodeSearchMatches.forEach((item, index)=>{
            this.selectPostalCode(item.Code.toString());
        });
        this.findMatchingPostalCodes();
    }
    onRemoveAllSelectedPostalCodes(event){
        for (const [key, value] of Object.entries(this.postalCodes)) {
            if(value.selected){
                this.deselectPostalCode(value.Code);
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
        console.log('onSearchInputFocus');
        this._searchInputHasFocus = true;
    }
    onSearchInputBlur(event){
        console.log('onSearchInputBlur');
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