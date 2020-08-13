/**
 * Created by Hugo on 07/08/2020.
 */

import {LightningElement, track} from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import leaflet from '@salesforce/resourceUrl/leaflet';
import GeoJSON from '@salesforce/resourceUrl/GeoJSON';
import TownshipsGeoJSON from '@salesforce/resourceUrl/townships';


export default class LeadGeneratorLocation extends LightningElement {


    /*
     * The mutable province data determining how the features should be shown on the map.
     */

    @track _provinces = {
        'Drenthe' : {
            show_on_map : true},
        'Flevoland' : {
            show_on_map : true },
        'Friesland' : {
            show_on_map : true },
        'Gelderland' : {
            show_on_map : true },
        'Groningen' : {
            show_on_map : true },
        'Limburg' : {
            show_on_map : true },
        'Noord-Brabant' : {
            show_on_map : true },
        'Noord-Holland' : {
            show_on_map : true },
        'Overijssel' : {
            show_on_map : true },
        'Utrecht' : {
            show_on_map : true },
        'Zeeland' : {
            show_on_map : true },
        'Zuid-Holland' : {
            show_on_map : true },
    }
    @track _townshipsIndex = {

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
        fillColor : 'green'
    }
    deselectedStyle = {
        opacity : 0.2,
        fillColor : 'red'
    }


    _leafletMap;
    _leafletMapHTMLElement;
    _leafletLibraryLoaded = false;
    _leafletMapLoaded = false;

    _openStreetMapTileLayer;

    _geoJSON;
    _geoJSONLayer;

    _townshipsGeoJSON;
    _townshipsGeoJSONLayer;

    connectedCallback() {
        this.loadLeaflet();
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
        let request = new XMLHttpRequest();
        request.open("GET", GeoJSON, false);
        request.send(null);
        this._geoJSON = JSON.parse(request.responseText)[0];

        request = new XMLHttpRequest();
        request.open("GET", TownshipsGeoJSON, false);
        request.send(null);
        this._townshipsGeoJSON = JSON.parse(request.responseText);
        console.log(this._townshipsGeoJSON);
        Promise.resolve();
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
            this._leafletMap = L.map(this._leafletMapHTMLElement).setView([52.2044968, 5.6275306], 7);
            this._openStreetMapTileLayer = L.tileLayer(
                'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                {
                    maxZoom: 15,
                    minZoom: 1,
                })
                .addTo(this._leafletMap);
            try{
                this.initProvincesGeoJSON();
                this.initTownshipGeoJSON();
            }catch (e) {
                console.log(e);
            }
            this.showLayer(this.mapType);
            this._leafletMap.setMaxBounds(this._geoJSONLayer.getBounds());

        }
    }

    initProvincesGeoJSON(){
        if(this._geoJSONLayer == null){
            this._geoJSONLayer = L.geoJSON(this._geoJSON,{
                onEachFeature: ((feature, layer) =>{
                    layer.setStyle(this._provinces[feature.properties.name].show_on_map ? this.selectedStyle : this.deselectedStyle);
                    layer.on('click', (event)=>{
                        this.provinceFeatureClicked(feature,layer,this);
                    });
                })
            })
        }
    }
    initTownshipGeoJSON(){
        if(this._townshipsGeoJSONLayer == null){
            this._townshipsGeoJSON.features.forEach((feature, index)=>{
                this._townshipsIndex[feature.properties.name] = feature;
            });
            this._townshipsGeoJSONLayer = L.geoJSON(this._townshipsGeoJSON,{
                onEachFeature: ((feature, layer) =>{
                    this._townshipsIndex[feature.properties.name].show_on_map = false;
                    layer.setStyle(this._townshipsIndex[feature.properties.name].show_on_map ? this.selectedStyle : this.deselectedStyle);
                    layer.on('click', (event)=>{
                        this.townshipFeatureClicked(feature,layer,this);
                    });
                })
            });
        }
        console.log(this._townshipsGeoJSON.features);

        console.log(this._townshipsIndex);

    }
    showLayer(typeName){
        if(typeName =="Provinces") this.showProvinces();
        if(typeName =="Townships") this.showTownships();
    }
    showProvinces(){
        this._townshipsGeoJSONLayer.remove();
        this._geoJSONLayer.addTo(this._leafletMap);
    }
    showTownships(){
        this._geoJSONLayer.remove();
        this._townshipsGeoJSONLayer.addTo(this._leafletMap);
    }

    getProvinceFeatureLayer(provinceName){
        let foundLayer = null;
        this._geoJSONLayer.eachLayer((layer) => {
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
    townshipFeatureClicked(feature, layer, controller){
        try{
            let township = controller._townshipsIndex[feature.properties.name];

            let show_on_map = township.show_on_map;

            if(show_on_map == null || show_on_map === false){
                township.show_on_map = true;
                layer.setStyle(this.selectedStyle);
            }
            else if(show_on_map == true){
                township.show_on_map = false;
                layer.setStyle(this.deselectedStyle);
            }
        }catch (e){
            console.log(e);
        }


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

    _mapType = "Provinces";
    get mapType(){
        return this._mapType;
    }
    set mapType(value){
        this._mapType = value;
        this.showLayer(this._mapType);

    }

    onTypeButtonClicked(event){
        let target = event.target;
        this.mapType = target.name;
    }

}