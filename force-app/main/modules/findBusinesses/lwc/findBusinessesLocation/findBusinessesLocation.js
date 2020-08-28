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
        POSTALCODE : 'POSTALCODE',
        CITY : 'CITY',
    }

    /*
     * Styles to present the map
     */
    selectedStyle = {
        opacity : 0.5,
        color : '#a09f9f',
        fillColor : '#049d3c',
        fillOpacity : 0.8,
        radius: 300,
        weight : 1,
    }
    deselectedStyle = {
        opacity : 0.1,
        color : '#000000',
        fillColor : '#c59dff',
        fillOpacity : 0.4,
        radius: 250,
        weight : 1,
    }

    /*
     * Sets the selected layer to present.
     */
    _selectedMapLayer = this.MAP_LAYERS.PROVINCE;
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
        if(this.selectedMapLayer === this.MAP_LAYERS.CITY ) return this.getSelectedCities();
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
    getSelectedCities(){
        let selectedCities = [];
        for (const [key, value] of Object.entries(this.cities)) {
            if(value.selected === true) selectedCities.push(value.City);
        }
        let response = {
            locations : selectedCities,
            type : this.MAP_LAYERS.CITY
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
        this.loadProvincesData();
        this.loadPostalCodesData();
        this.loadCitiesData();
        Promise.resolve();
    }
    loadProvincesData(){
        let request = new XMLHttpRequest();
        request.open("GET", GeoJSONProvinces, false);
        request.send(null);
        this.provincesData = JSON.parse(request.responseText)[0];
    }
    loadPostalCodesData(){
        let request = new XMLHttpRequest();
        request.open("GET", postalCodesData, false);
        request.send(null);
        this.postalCodesData = JSON.parse(request.responseText);
    }
    loadCitiesData(){
        let request = new XMLHttpRequest();
        request.open("GET", postalCodesData, false);
        request.send(null);
        this.citiesData = JSON.parse(request.responseText);
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
                this.initCities();

            }catch (e) {
                console.log(e);
            }
            this.showLayer(this.selectedMapLayer);
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
            this._leafletMap.removeLayer(this.citiesLayer);
            this._leafletMap.removeLayer(this.postalCodesLayer);
            this.provincesLayer.addTo(this._leafletMap);
        }
        if (layerName == this.MAP_LAYERS.POSTALCODE){
            this._leafletMap.removeLayer(this.provincesLayer);
            this._leafletMap.removeLayer(this.citiesLayer);
            this.postalCodesLayer.addTo(this._leafletMap);
        }
        if (layerName == this.MAP_LAYERS.CITY){
            this._leafletMap.removeLayer(this.provincesLayer);
            this._leafletMap.removeLayer(this.postalCodesLayer);
            this.citiesLayer.addTo(this._leafletMap);
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
     * Postal Code
     */
    postalCodesData;
    postalCodesLayer;
    postalCodesDataLoaded = false;
    @track postalCodes = {};

    initPostalCodes(){
        if(this.postalCodesDataLoaded == false){
            this.postalCodesDataLoaded = true;
            this.postalCodesLayer = L.layerGroup();
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
    selectPostalCode(id){
        this.postalCodes[id].selected = true;
        this.postalCodes[id].layerElement.setStyle(this.selectedStyle);
        this.postalCodes[id].layerElement.setRadius(this.selectedStyle.radius);
        let bulkInputPostalCode = this.template.querySelector("c-bulk-input[data-identifier="+this.MAP_LAYERS.POSTALCODE+"]");
        bulkInputPostalCode.addSelectedItem(id);
    }
    deselectPostalCode(id){
        this.postalCodes[id].selected = false;
        this.postalCodes[id].layerElement.setStyle(this.deselectedStyle);
        this.postalCodes[id].layerElement.setRadius(this.deselectedStyle.radius);
        let bulkInputPostalCode = this.template.querySelector("c-bulk-input[data-identifier="+this.MAP_LAYERS.POSTALCODE+"]");
        bulkInputPostalCode.removeSelectedItem(id);
    }
    handlePostalCodeClicked(event){
        let postalCodeId = event.detail.id;
        let selected = event.detail.selected;
        if(selected){
            this.selectPostalCode(postalCodeId);
        }else{
            this.deselectPostalCode(postalCodeId);
        }
    }

    /*
     * cities
     */

    citiesData;
    citiesLayer;
    citiesDataLoaded = false;
    @track cities = {};

    initCities(){
        if(this.citiesDataLoaded == false){
            this.citiesDataLoaded = true;
            this.citiesLayer = L.layerGroup();
            let controller = this;

            let citiesMap = {};
            this.citiesData.forEach((item, index)=> {
                let cityId = item.City+item.Municipality+item.Province;
                if(citiesMap[cityId] == null){
                    citiesMap[cityId] = {
                        coordinates: [],
                    }
                }
                citiesMap[cityId].coordinates.push([item.Lat, item.Lon]);
                citiesMap[cityId]['duplicateCityName'] = false;
                this.citiesData.forEach((duplicateItem, duplicateIndex)=> {
                    if(item.City == duplicateItem.City && item.Municipality != duplicateItem.Municipality)
                        citiesMap[cityId]['duplicateCityName'] = true;
                });
                citiesMap[cityId]['selected'] = false;
                if(citiesMap[cityId]['duplicateCityName'] == true){
                    citiesMap[cityId]['label'] = item.City + " (" + item.Municipality + ")";
                }else{
                    citiesMap[cityId]['label'] = item.City;
                }
                citiesMap[cityId]['City'] = item.City;
                citiesMap[cityId]['id'] = cityId;
            });
            for (const [key, value] of Object.entries(citiesMap)) {
                let centerCoordinate = this.getLatLngCenter(value.coordinates);
                citiesMap[key]['centerCoordinate'] = centerCoordinate;
                let cityCircle = L.circle([centerCoordinate[0], centerCoordinate[1]], this.deselectedStyle);
                cityCircle.setRadius(this.deselectedStyle.radius  * 1.5);
                cityCircle.on("click", (feature, layer)=>{
                    let cityId = citiesMap[key].id;
                    if(!controller.cities[cityId].selected){
                        controller.selectCity(cityId);
                    }else{
                        controller.deselectCity(cityId);
                    }
                });
                citiesMap[key]['layerElement'] = cityCircle;
                this.cities[citiesMap[key].id] = value;
                this.citiesLayer.addLayer(cityCircle);
            }
        }
    }

    selectCity(cityId){
        this.cities[cityId].selected = true;
        this.cities[cityId].layerElement.setStyle(this.selectedStyle);
        this.cities[cityId].layerElement.setRadius(this.selectedStyle.radius * 1.5);
        let bulkInputCity = this.template.querySelector("c-bulk-input[data-identifier="+this.MAP_LAYERS.CITY+"]");
        bulkInputCity.addSelectedItem(cityId);
    }
    deselectCity(cityId){
        this.cities[cityId].selected = false;
        this.cities[cityId].layerElement.setStyle(this.deselectedStyle);
        this.cities[cityId].layerElement.setRadius(this.deselectedStyle.radius  * 1.5);
        let bulkInputCity = this.template.querySelector("c-bulk-input[data-identifier="+this.MAP_LAYERS.CITY+"]");
        bulkInputCity.removeSelectedItem(cityId);
    }

    handleCityClicked(event){
        let cityId = event.detail.id;
        let selected = event.detail.selected;
        if(selected){
            this.selectCity(cityId);
        }else{
            this.deselectCity(cityId);
        }
    }


    rad2degr(rad) { return rad * 180 / Math.PI; }
    degr2rad(degr) { return degr * Math.PI / 180; }

    /**
     * @param latLngInDeg array of arrays with latitude and longtitude
     *   pairs in degrees. e.g. [[latitude1, longtitude1], [latitude2
     *   [longtitude2] ...]
     *
     * @return array with the center latitude longtitude pairs in
     *   degrees.
     */
    getLatLngCenter(latLngInDegr) {
        var LATIDX = 0;
        var LNGIDX = 1;
        var sumX = 0;
        var sumY = 0;
        var sumZ = 0;

        for (var i=0; i<latLngInDegr.length; i++) {
            var lat = this.degr2rad(latLngInDegr[i][LATIDX]);
            var lng = this.degr2rad(latLngInDegr[i][LNGIDX]);
            // sum of cartesian coordinates
            sumX += Math.cos(lat) * Math.cos(lng);
            sumY += Math.cos(lat) * Math.sin(lng);
            sumZ += Math.sin(lat);
        }

        var avgX = sumX / latLngInDegr.length;
        var avgY = sumY / latLngInDegr.length;
        var avgZ = sumZ / latLngInDegr.length;

        // convert average x, y, z coordinate to latitude and longtitude
        var lng = Math.atan2(avgY, avgX);
        var hyp = Math.sqrt(avgX * avgX + avgY * avgY);
        var lat = Math.atan2(avgZ, hyp);

        return ([this.rad2degr(lat), this.rad2degr(lng)]);
    }
}