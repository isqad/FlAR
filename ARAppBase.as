package 
{
    import ARAppBase.*;
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import org.libspark.flartoolkit.core.*;
    import org.libspark.flartoolkit.core.param.*;
    import org.libspark.flartoolkit.core.raster.rgb.*;
    import org.libspark.flartoolkit.detector.*;

    public class ARAppBase extends Sprite
    {
        private var _loader:URLLoader;
        private var _cameraFile:String;
        private var _codeFile:String;
        private var _width:int;
        private var _height:int;
        private var _codeWidth:int;
        protected var _param:FLARParam;
        protected var _code:FLARCode;
        protected var _raster:FLARRgbRaster_BitmapData;
        protected var _detector:FLARSingleMarkerDetector;
        protected var _webcam:Camera;
        protected var _video:Video;
        protected var _capture:Bitmap;
        protected var _nowebcam:Sprite;

        public function ARAppBase()
        {
            _nowebcam = new nowebcam();
            return;
        }// end function

        protected function init(param1:String, param2:String, param3:int = 320, param4:int = 240, param5:int = 80) : void
        {
            _cameraFile = param1;
            _width = param3;
            _height = param4;
            _codeFile = param2;
            _codeWidth = param5;
            _loader = new URLLoader();
            _loader.dataFormat = URLLoaderDataFormat.BINARY;
            _loader.addEventListener(Event.COMPLETE, _onLoadParam);
            _loader.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
            _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
            _loader.load(new URLRequest(_cameraFile));
            return;
        }// end function

        private function _onLoadParam(event:Event) : void
        {
            _loader.removeEventListener(Event.COMPLETE, _onLoadParam);
            _param = new FLARParam();
            _param.loadARParam(_loader.data);
            _param.changeScreenSize(_width, _height);
            _loader.dataFormat = URLLoaderDataFormat.TEXT;
            _loader.addEventListener(Event.COMPLETE, _onLoadCode);
            _loader.load(new URLRequest(_codeFile));
            return;
        }// end function

        private function _onLoadCode(event:Event) : void
        {
            _code = new FLARCode(16, 16);
            _code.loadARPatt(_loader.data);
            _loader.removeEventListener(Event.COMPLETE, _onLoadCode);
            _loader.removeEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
            _loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
            _loader = null;
            _webcam = Camera.getCamera();
            if (!_webcam)
            {
                _nowebcam.x = 320;
                _nowebcam.y = 240;
                addChild(_nowebcam);
                throw new Error("No webcam!!!!");
            }
            _webcam.setMode(_width, _height, 30);
            _video = new Video(_width, _height);
            _video.attachCamera(_webcam);
            _capture = new Bitmap(new BitmapData(_width, _height, false, 0), PixelSnapping.AUTO, true);
            _raster = new FLARRgbRaster_BitmapData(_capture.bitmapData);
            _detector = new FLARSingleMarkerDetector(_param, _code, _codeWidth);
            _detector.setContinueMode(true);
            dispatchEvent(new Event(Event.INIT));
            return;
        }// end function

        protected function onInit() : void
        {
            return;
        }// end function

    }
}
