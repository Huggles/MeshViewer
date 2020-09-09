/**
 * Created by Hugo on 07/09/2020.
 */

import {LightningElement, api} from 'lwc';

import {
    Scene,
    Vector3,
    PerspectiveCamera,
    WebGLRenderer,
    GridHelper,
    AmbientLight,
    DirectionalLight,
    LoadingManager,
    Clock,
    Sky,
    OrbitControls,
    TransformControls,
    FirstPersonControls,
    OBJLoader,
    MTLLoader,
    DDSLoader,
} from 'c/three_module';

export default class MeshViewerModule extends LightningElement {





    /*
     * User Interface
     */
    canvasRenderer;

    renderCanvasSizeSmall = 'canvas_small';
    renderCanvasSizeFullScreen = 'canvas_fullscreen';
    renderCanvasSize = 'canvas_fullscreen';

    onToggleFullScreen(){
        if(this.renderCanvasSize === this.renderCanvasSizeSmall){
            this.renderCanvasSize = this.renderCanvasSizeFullScreen;
        }else{
            this.renderCanvasSize = this.renderCanvasSizeSmall;
        }
    }


    /*
     * Lifecycle Functions
     */

    //A clock that maintains the time this component exists.
    clock;

    connectedCallback() {
        this.clock = new Clock();
    }
    renderedCallback() {
        let cr = this.template.querySelector('[data-identifier="canvasRenderer"]');
        if(cr != null && this.canvasRenderer == null){
            this.canvasRenderer = cr;
            this.initScene();
        }
    }

    /*
     * ThreeJS Functions
     */

    //Defaults
    cameraDefaults = {};
    aspectRatio = 2;

    //Variables
    scene;
    camera;
    cameraTarget;
    renderer;
    grid;
    sky;

    initScene(){
        let self = this;
        if(self.canvasRenderer != null){
            self.cameraDefaults = {
                posCamera: new Vector3(200.0, 200.0, 200.0 ),
                posCameraTarget: new Vector3( 0, 0, 0 ),
                near: 0.1,
                far: 10000,
                fov: 45
            };
            self.cameraTarget = self.cameraDefaults.posCameraTarget;
            try{
                window.addEventListener( 'resize', (event)=>{
                    console.log('window resized');
                    self.resizeDisplayGL();
                }, false );
                self.initGL();
                self.initContent();
                self.initSky();
                self.initTransformControl();
                self.resizeDisplayGL();
                self.resetCamera();
                self.animate();
            }catch (e) {
                console.log('error');
                console.log(e);
            }
        }
    }
    initGL(){
        let self = this;

        self.scene = new Scene();
        self.camera = new PerspectiveCamera(
            self.cameraDefaults.fov, self.aspectRatio,
            self.cameraDefaults.near, self.cameraDefaults.far );

        let renderer = new WebGLRenderer( {
            canvas: self.canvasRenderer,
            antialias: true
        } );
        renderer.setClearColor( 0x050505 );
        self.renderer = renderer;


        this.grid = new GridHelper( 1200, 60, 0xFF4444, 0x404040 );
        self.scene.add( this.grid );
        //
        let ambientLight = new AmbientLight( 0x888888 );
        let directionalLight1 = new DirectionalLight( 0xC0C090 );
        let directionalLight2 = new DirectionalLight( 0xC0C090 );
        directionalLight1.position.set( - 100, - 50, 100 );
        directionalLight2.position.set( 100, 50, - 100 );
        self.scene.add( directionalLight1 );
        self.scene.add( directionalLight2 );
        self.scene.add( ambientLight );
    }

    onToggleGrid(event){
        let gridId = this.scene.getObjectById(this.grid.id);
        if(gridId){
            this.scene.remove( this.grid );
        }else{
            this.scene.add( this.grid );
        }
        this.renderCanvas();

    }


    /*
     * Content Functions
     */

    initContent(){
        let self = this;
        let manager = new LoadingManager();
        manager.addHandler( /\.dds$/i, new DDSLoader() );

        let modelPath = 'https://materializepoc1.s3.eu-central-1.amazonaws.com/male02' + '/';
        new MTLLoader( manager )
            .setPath( modelPath )
            .load( 'male02_dds.mtl', function ( materials ) {
                materials.preload();
                new OBJLoader( manager )
                    .setMaterials( materials )
                    .setPath( modelPath )
                    .load( 'male02.obj', function ( object ) {
                        object.position.x = 0;
                        object.position.y = 0;
                        object.position.z = 0;
                        object.scale.x = 0.5;
                        object.scale.y = 0.5;
                        object.scale.z = 0.5;

                        object.updateMatrixWorld();
                        self.scene.add( object );

                        self.transformControls.attach(object);
                        self.transformControls.setMode( "translate" );
                        self.renderCanvas();
                    }, (xhr)=>{

                    }, (error)=>{
                        console.log('error');
                        console.log(error);
                    } );
            } );
    }

    initSky(){
        let self = this;

        self.sky = new Sky();
        self.sky.scale.setScalar( 450000 );
        self.scene.add( self.sky );
        let sun = new Vector3();

        /// GUI

        let effectController = {
            turbidity: 10,
            rayleigh: 3,
            mieCoefficient: 0.005,
            mieDirectionalG: 0.7,
            inclination: 0.49, // elevation / inclination
            azimuth: 0.25, // Facing front,
            exposure: 0.5,
        };
        let uniforms = self.sky.material.uniforms;
        uniforms[ "turbidity" ].value = effectController.turbidity;
        uniforms[ "rayleigh" ].value = effectController.rayleigh;
        uniforms[ "mieCoefficient" ].value = effectController.mieCoefficient;
        uniforms[ "mieDirectionalG" ].value = effectController.mieDirectionalG;
        let theta = Math.PI * ( effectController.inclination - 0.5 );
        let phi = 2 * Math.PI * ( effectController.azimuth - 0.5 );
        sun.x = Math.cos( phi );
        sun.y = Math.sin( phi ) * Math.sin( theta );
        sun.z = Math.sin( phi ) * Math.cos( theta );
        uniforms[ "sunPosition" ].value.copy( sun );
        self.renderer.toneMappingExposure = effectController.exposure;
    }
    onToggleSkybox(event){
        let skyboxId = this.scene.getObjectById(this.sky.id);
        if(skyboxId){
            this.scene.remove( this.sky );
        }else{
            this.scene.add( this.sky );
        }
        this.renderCanvas();
    }


    /*
     * Controls
     */
    orbitControls;
    transformControls;
    firstPersonControls;


    @api availableTransformControls = ['translate','rotate','scale'];

    initTransformControl() {
        let self = this;
        // this.orbitControls = new OrbitControls( this.camera,  self.canvasRenderer );
        // this.orbitControls.update();
        // this.orbitControls.addEventListener( 'change', ()=>{
        //     self.renderCanvas();
        // } );
        self.firstPersonControls = new FirstPersonControls( self.camera,  self.canvasRenderer );
        self.firstPersonControls.lookAt(self.cameraTarget);
        self.firstPersonControls.update(this.clock.getDelta());

        self.firstPersonControls.movementSpeed = 1000;
        self.firstPersonControls.lookSpeed = 0.1;
        self.firstPersonControls.activeLook = true;
        self.firstPersonControls.mouseMovement = false;
        self.firstPersonControls.enabled = false;

        self.transformControls = new TransformControls( self.camera,  self.canvasRenderer );
        self.transformControls.addEventListener( 'change', (event)=>{
            self.renderCanvas();
        } );
        self.transformControls.addEventListener( 'dragging-changed', (event)=>{
            self.firstPersonControls.enabled = ! event.value;
        } );
        self.scene.add(self.transformControls);
        window.addEventListener('keydown', (event) => {
            self.onKeyPressedEvent(event.key, self);
        });
        self.canvasRenderer.addEventListener('mousedown', (event) => {
            console.log('mouse down');
            console.log(event.button);
            if(event.button === 2){ // Right mouse clicked
                console.log('self.firstPersonControls.enabled');

                self.firstPersonControls.enabled = true;
                self.firstPersonControls.update(self.clock.getDelta());
                console.log(self.firstPersonControls.enabled);
                self.animate();
            }
        }, false);
        self.canvasRenderer.addEventListener('mouseup', (event) => {
            console.log('mouse up');
            console.log(event.button);
            if(event.button === 2){ // Right mouse released
                self.firstPersonControls.enabled = false;
                self.firstPersonControls.update(self.clock.getDelta());
                self.animate();

            }
        }, false);
    }
    onKeyPressedEvent(key, self){
        switch (key) {
            case "t":
                self.setTransformControlsMode("translate", self);
                break;
            case "q":
                self.setTransformControlsMode("scale", self);
                break;
            case "r":
                self.setTransformControlsMode( "rotate", self);
                break;
            case "+":
                self.transformControls.setSize(  self.transformControls.size + 0.1 );
                break;
            case "-":
                self.transformControls.setSize( Math.max(  self.transformControls.size - 0.1, 0.1 ) );
                break;
        }
    }

    onControlModeClicked(event){
        let identifier = event.target.dataset['identifier'];
        this.setTransformControlsMode(identifier, this);
    }

    setTransformControlsMode(mode, self){
        if(self.transformControls != null){
            self.transformControls.setMode(mode);
        }
    }
    /*
     * Camera / Render Functions
     */
    resetCamera() {
        this.camera.position.x = this.cameraDefaults.posCamera.x;
        this.camera.position.y = this.cameraDefaults.posCamera.y;
        this.camera.position.z = this.cameraDefaults.posCamera.z;
        this.cameraTarget = this.cameraDefaults.posCameraTarget;
        this.updateCamera();
    }
    updateCamera() {
        this.camera.aspect = this.aspectRatio;
        this.camera.lookAt( this.cameraTarget );
        this.camera.updateProjectionMatrix();
    }

    resizeDisplayGL() {
        this.canvasRenderer = this.template.querySelector('[data-identifier="canvasRenderer"]');
        this.recalcAspectRatio();
        this.renderer.setSize( this.canvasRenderer.offsetWidth, this.canvasRenderer.offsetHeight, false );
        this.updateCamera();
        this.renderCanvas();
    }
    recalcAspectRatio() {
        this.aspectRatio = (this.canvasRenderer.offsetHeight === 0) ? 1 : this.canvasRenderer.offsetWidth / this.canvasRenderer.offsetHeight;
    }
    animate(){
        requestAnimationFrame( ()=>{
            this.animate();
        } );
        this.renderCanvas();
    }
    renderCanvas(){
        try{
            this.firstPersonControls.update(this.clock.getDelta());
            this.renderer.render( this.scene, this.camera );
        }catch (e) {
            console.log(e);
        }
    }
}
