 import JSServe
using JSServe
using JSServe: @js_str
using JSServe.DOM

## DEPRECATED MAIN METHODS USE MESHCAT

# Javascript & CSS dependencies can be declared locally and
# freely interpolated in the DOM / js string, and will make sure it loads
const THREE = JSServe.Dependency(
    :THREE, # name of the Javascript module
    # Could also include additional css dependencies here
    ["https://cdnjs.cloudflare.com/ajax/libs/three.js/r119/three.js"]
)
const OrbitControls = JSServe.Dependency(
    :OrbitControls, # name of the Javascript module
    # Could also include additional css dependencies here
    ["https://cdn.jsdelivr.net/npm/three-orbitcontrols@2.110.3/OrbitControls.min.js"]
)

function dom_handler(session, request)
    width = 1000; height = 1000
    dom = DOM.div(width = width, height = height)
    JSServe.onload(session, dom, js"""
        function (container){
            var renderer = new $(THREE).WebGLRenderer({antialias: true});
            renderer.setSize($width, $height);
            renderer.setClearColor("#ffffff");
            container.appendChild(renderer.domElement);
            var scene = new $THREE.Scene();
			var SCREEN_WIDTH = window.innerWidth, SCREEN_HEIGHT = window.innerHeight;
			var VIEW_ANGLE = 45, ASPECT = SCREEN_WIDTH / SCREEN_HEIGHT, NEAR = 0.1, FAR = 10000;
			renderer.setSize(SCREEN_WIDTH, SCREEN_HEIGHT);
			camera = new THREE.PerspectiveCamera( VIEW_ANGLE, ASPECT, NEAR, FAR);
			camera.position.set(0,150,400);
			camera.lookAt(scene.position);
            var ambientLight = new $(THREE).AmbientLight(0xcccccc, 0.4);
            scene.add(ambientLight);
            var pointLight = new $(THREE).PointLight(0xffffff, 0.8);
            camera.add(pointLight);
            scene.add(camera);

			// Grid Creation for each of the planes

			var gridXZ = new $(THREE).GridHelper(300, 10);
			gridXZ.setColors( new THREE.Color(0x006600), new $(THREE).Color(0x006600) );
			gridXZ.position.set( 100,0,100 );
			scene.add(gridXZ);

			var gridXY = new $(THREE).GridHelper(300, 10);
			gridXY.position.set( 100,100,0 );
			gridXY.rotation.x = Math.PI/2;
			gridXY.setColors( new THREE.Color(0x000066), new THREE.Color(0x000066) );
			scene.add(gridXY);

			var gridYZ = new $(THREE).GridHelper(300, 10);
			gridYZ.position.set( 0,100,100 );
			gridYZ.rotation.z = Math.PI/2;
			gridYZ.setColors( new THREE.Color(0x660000), new THREE.Color(0x660000) );
			scene.add(gridYZ);

			// test arrow
			var origin = new $(THREE).Vector3(50,100,50);
			var terminus  = new $(THREE).Vector3(75,75,75);
			var direction = new $(THREE).Vector3().subVectors(terminus, origin).normalize();
			var arrow = new $(THREE).ArrowHelper(direction, origin, 50, 0x884400);
			scene.add(arrow);

			renderer.render( scene, camera );
        }


    """)
    return dom
end

isdefined(Main, :app) && close(app)

app = JSServe.Application(
    dom_handler,
    "127.0.0.1", 8081, verbose = false
)
