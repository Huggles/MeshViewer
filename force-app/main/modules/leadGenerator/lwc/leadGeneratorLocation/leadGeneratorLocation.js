/**
 * Created by Hugo on 07/08/2020.
 */

import {LightningElement} from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import leaflet from '@salesforce/resourceUrl/leaflet';
import GeoJSON from '@salesforce/resourceUrl/GeoJSON';


export default class LeadGeneratorLocation extends LightningElement {

    _leafletMap;
    _leafletMapElement;
    _leafletLibraryLoaded = false;
    _leafletMapLoaded = false;

    _geoJSON;

    connectedCallback() {
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
        this._geoJSON = JSON.parse(request.responseText);
        Promise.resolve();
    }

    renderedCallback() {
        this._leafletMapElement = this.template.querySelector("[data-identifier='leafletMap']");
        if(this._leafletMapElement  != null){
            this.initLeafletMap();
        }
    }

    initLeafletMap(){
        if(this._leafletMapElement != null && this._leafletLibraryLoaded == true && this._leafletMapLoaded == false){
            console.log('loading map properties');
            this._leafletMapLoaded = true;
            this._leafletMap = L.map(this._leafletMapElement).setView([52.2044968, 5.6275306], 7);
            L.tileLayer(
                'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                {
                    maxZoom: 18,
                })
                .addTo(this._leafletMap);
            L.geoJSON(this._geoJSON).addTo(this._leafletMap);
        }
    }

}