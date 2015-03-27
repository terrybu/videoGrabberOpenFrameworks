#include "ofApp.h"


ofVideoGrabber videoGrabber;
ofTexture textureInversion;
unsigned char * videoColorInversionPixels;

ofTexture textureGray;
unsigned char * videoGrayPixels;

ofTexture textureMirror;

ofTexture textureTerry;
unsigned char * videoTerryPixels;

int camWidth;
int camHeight;

ofTrueTypeFont verdana;


//--------------------------------------------------------------
void ofApp::setup(){	
//	ofSetOrientation(OF_ORIENTATION_90_RIGHT);
    //Set iOS to Orientation Landscape Right
    
    camWidth  = 480;
    camHeight = 360;
    
	ofSetFrameRate(30);
    videoGrabber.setVerbose(true);
	videoGrabber.initGrabber(camWidth, camHeight, OF_PIXELS_BGRA);
    
    //COLOR INVERSION
	videoColorInversionPixels = new unsigned char[(int) (camWidth * camHeight * 3.0)];
    textureInversion.allocate(camWidth, camHeight, GL_RGB);

    //GRAYSCALE & MIRROR CODE
    videoGrayPixels = new unsigned char[camWidth*camHeight];
    textureGray.allocate(camWidth, camHeight, GL_LUMINANCE);
    
    //MIRROR
    textureMirror.allocate(camWidth, camHeight, GL_RGB);
    
    //CUSTOM
    videoTerryPixels = new unsigned char[(int) (camWidth * camHeight * 3.0)];
    textureTerry.allocate(camWidth, camHeight, GL_RGB);

    verdana.loadFont("verdana.ttf", 8);
}

//--------------------------------------------------------------
void ofApp::update(){
	ofBackground(255,255,255);
    videoGrabber.update(); //this simple call basically allows ofVideoGrabber to keep pulling video stream into itself

    if (videoGrabber.isFrameNew()) {
        unsigned char * srcPixels = videoGrabber.getPixels();
        
        //GRAY AND MIRROR
        int counter = 0;
        // convert color image to rgb
        for (int i = 0; i < camHeight; i++) {
            for (int j = 0; j < camWidth*3; j+=3) {
                // get r, g and b components
                int r = (i*camWidth*3) + j;
                int g = (i*camWidth*3) + (j+1);
                int b = (i*camWidth*3) + (j+2);
                int grayPixel = (11 * srcPixels[r] + 16 * srcPixels[g] + 5 * srcPixels[b]) / 32;
                videoGrayPixels[counter] = grayPixel;
                counter++;
            }
        }
        textureGray.loadData(videoGrayPixels, videoGrabber.getWidth(), videoGrabber.getHeight(), GL_LUMINANCE);
        
        //COLOR INVERSION
        int totalPix = videoGrabber.getWidth() * videoGrabber.getHeight() * 3;
        for(int k = 0; k < totalPix; k+= 3){
            videoColorInversionPixels[k  ] = 255 - srcPixels[k];
            videoColorInversionPixels[k+1] = 255 - srcPixels[k+1];
            videoColorInversionPixels[k+2] = 255 - srcPixels[k+2];
        }
        textureInversion.loadData(videoColorInversionPixels, videoGrabber.getWidth(), videoGrabber.getHeight(), GL_RGB);
        
        //MIRROR
        //The standard way to mirror is to manipulate each pixel like you see above, but http://trick7.com/2014/03/of-ofvideograbber_mirror/ had a good trick to do it a lot easier like this
        textureMirror = videoGrabber.getTextureReference();
        
        //CUSTOM
        for(int k = 0; k < totalPix; k+= 3){
            videoTerryPixels[k  ] = srcPixels[k] + 10;
            videoTerryPixels[k+1] = srcPixels[k+1] + 60;
            videoTerryPixels[k+2] = srcPixels[k+2] + 110;
        }
        textureTerry.loadData(videoTerryPixels, videoGrabber.getWidth(), videoGrabber.getHeight(), GL_RGB);
    }
    
}

//--------------------------------------------------------------
void ofApp::draw(){
	ofSetColor(255);
	videoGrabber.draw(0, 0);
    //this just "draws" the video live stream into the screen, taking up the whole screen
    
    //GRAY SCALE
    textureGray.draw(0, 0, 120, 120);
    //this gets ofTexture to draw whatever data is loaded inside into that x,y,width,height coordinate
    
    //COLOR INVERSION
    textureInversion.draw(120, 0, 120, 120);
    
    //ROTATE STREAM
//    第3引数の-camWidthで反転する。
//    反転すると座標も反転するので(0,0)に表示させたい場合は(camWidth,0)と指定してやる
    textureMirror.draw(120, 120, -120, 120);
    
    //TERRY CUSTOM
    textureTerry.draw(120, 120, 120, 120);
    
    //STRINGS for label
    verdana.drawString("Normal Camera", 0, camHeight+20);
    verdana.drawString("Grayscale", 0, 10);
    verdana.drawString("Inversion Color", 120, 10);
    verdana.drawString("Mirror", 0, 130);
    verdana.drawString("Custom", 120, 130);
}

//--------------------------------------------------------------
void ofApp::exit(){
    
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::lostFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){
    
}


