/**
 * Created by Hugo on 07/08/2020.
 */

import {LightningElement, track, api} from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import leaflet from '@salesforce/resourceUrl/leaflet';
import GeoJSON from '@salesforce/resourceUrl/GeoJSON';


export default class LeadGeneratorLocation extends LightningElement {


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
    @api selectedProvinces = {

    }

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
        this.loadInitialData();
        this.loadLeaflet();
    }
    loadInitialData(){
        if(this.selectedProvinces != null){
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
        let request = new XMLHttpRequest();
        request.open("GET", GeoJSON, false);
        request.send(null);
        this._geoJSON = JSON.parse(request.responseText)[0];
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
            this._leafletMap = L.map(this._leafletMapHTMLElement, {
                zoomDelta: 0.25,
                zoomSnap: 0.25,

            }).setView([52.2044968, 5.6275306], 6.5);
            this._openStreetMapTileLayer = L.tileLayer(
                'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                {
                    maxZoom: 8,
                    minZoom: 6.5,
                })
                .addTo(this._leafletMap);
            try{
                this.initProvincesGeoJSON();
            }catch (e) {
                console.log(e);
            }
            this.showProvinces();


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
    showProvinces(){
        this._geoJSONLayer.addTo(this._leafletMap);
        this._leafletMap.setMaxBounds(this._geoJSONLayer.getBounds());
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
}