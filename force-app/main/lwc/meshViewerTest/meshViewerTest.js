/**
 * Created by Hugo on 01/09/2020.
 */

import {api, LightningElement, track} from 'lwc';
import {loadScript, loadStyle} from "lightning/platformResourceLoader";

import threeCoreResource from '@salesforce/resourceUrl/three';
import bamboo from '@salesforce/resourceUrl/bamboo';
import BananaTree from '@salesforce/resourceUrl/BananaTree';

export default class MeshViewerTest extends LightningElement {


    _threeLibraryLoaded;
    _canvasRenderer;

    connectedCallback() {
        this.loadThreeLibrary();
    }
    renderedCallback() {
        this._canvasRenderer = this.template.querySelector('[data-identifier="canvasRenderer"]');
        this.initScene();
    }

    loadThreeLibrary(){
        Promise.all([
            loadScript(this, threeCoreResource),
        ])
            .then(()=>{
                this._threeLibraryLoaded = true;
                this.initScene();
            }).catch((error)=>{
                console.log('error');
                console.log(error);
            })

    }

    _scene;
    _camera;
    _renderer;

    initScene(){
        if(this._canvasRenderer != null && this._threeLibraryLoaded === true){
            try{
                this._scene = new THREE.Scene();
                this._camera = new THREE.PerspectiveCamera( 50, 1, 0.1, 1000 );
                this._camera.position.set( 10, 0, 10 );

                let renderer = new THREE.WebGLRenderer( { antialias: true } );
                renderer.setSize(500,500);
                renderer.setPixelRatio( window.devicePixelRatio );
                renderer.outputEncoding = THREE.sRGBEncoding;
                renderer.toneMapping = THREE.ACESFilmicToneMapping;
                renderer.toneMappingExposure = 1;
                renderer.physicallyCorrectLights = true;

                this._renderer = renderer;

                this._canvasRenderer.appendChild( this._renderer.domElement );

                let self = this;
                var loader = new THREE.GLTFLoader();



                console.log(BananaTree);
                let object;
                loader.load( BananaTree + '/scene.gltf', (gltf)=>{
                    object = gltf.scene;
                    self._scene.add( object );

                }, undefined, function ( error ) {
                    console.error( error );
                } );
                var geometry = new THREE.BoxGeometry();
                var material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } );
                var cube = new THREE.Mesh( geometry, material );
                console.log( cube.position );
                this._scene.add( cube );

                var ambient = new THREE.AmbientLight( 0x888888 );
                this._scene.add( ambient );

                var groundMaterial = new THREE.MeshPhongMaterial( { color: 0xff0000 } );
                var ground = new THREE.Mesh( new THREE.PlaneBufferGeometry( 512, 512 ), groundMaterial );
                ground.rotation.z = 45;
                this._scene.add( ground );


                let frame = 0;
                let animate = ()=>{
                    requestAnimationFrame( animate );
                    frame += 0.1;
                    cube.position.y = Math.sin(frame);
                    this._renderer.render( this._scene, this._camera );
                }
                animate();




            }catch (e) {
                console.log('error');
                console.log(e);
            }


        }
    }
    animate(){

    }

}