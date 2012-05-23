package 
{
    import ARAppBase.*;
    import PV3DARApp.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.utils.*;
    import org.libspark.flartoolkit.core.transmat.*;
    import org.libspark.flartoolkit.support.pv3d.*;
    import org.papervision3d.render.*;
    import org.papervision3d.scenes.*;
    import org.papervision3d.view.*;

    public class PV3DARApp extends ARAppBase
    {
        protected var _base:Sprite;
        protected var _viewport:Viewport3D;
        protected var _camera3d:FLARCamera3D;
        protected var _scene:Scene3D;
        protected var _renderer:LazyRenderEngine;
        protected var _markerNode:FLARBaseNode;
        protected var _timer:Timer;
        protected var _showmodel:Boolean = false;
        protected var _mytitle:Sprite;
        protected var _mymdescription:Sprite;
        protected var _resultMat:FLARTransMatResult;

        public function PV3DARApp()
        {
            _mytitle = new mytitle();
            _mymdescription = new mydescription();
            _resultMat = new FLARTransMatResult();
            return;
        }// end function

        override protected function init(param1:String, param2:String, param3:int = 320, param4:int = 240, param5:int = 80) : void
        {
            addEventListener(Event.INIT, _onInit, false, int.MAX_VALUE);
            super.init(param1, param2, param3, param4, param5);
            return;
        }// end function

        private function _onInit(event:Event) : void
        {
            var _loc_2:* = new GlowFilter(16777215, 2, 6, 6, 5, 3, false, false);
            _timer = new Timer(5000);
            _timer.start();
            _timer.addEventListener(TimerEvent.TIMER, changeStatus);
            _base = addChild(new Sprite()) as Sprite;
            _capture.width = 640;
            _capture.height = 480;
            _base.addChild(_capture);
            _mytitle.x = 320;
            _mytitle.y = 50;
            _mytitle.filters = [_loc_2];
            _mytitle.visible = false;
            _mymdescription.x = 320;
            _mymdescription.y = 420;
            _mymdescription.visible = false;
            _mymdescription.filters = [_loc_2];
            _base.addChild(_mytitle);
            _base.addChild(_mymdescription);
            _viewport = _base.addChild(new Viewport3D(320, 240)) as Viewport3D;
            _viewport.scaleX = 2;
            _viewport.scaleY = 2;
            _viewport.x = -4;
            _camera3d = new FLARCamera3D(_param);
            _scene = new Scene3D();
            _markerNode = _scene.addChild(new FLARBaseNode()) as FLARBaseNode;
            _renderer = new LazyRenderEngine(_scene, _camera3d, _viewport);
            _markerNode.visible = false;
            addEventListener(Event.ENTER_FRAME, _onEnterFrame);
            return;
        }// end function

        private function _onEnterFrame(event:Event = null) : void
        {
            var e:* = event;
            _capture.bitmapData.draw(_video);
            var detected:Boolean;
            try
            {
                detected = _detector.detectMarkerLite(_raster, 80) && _detector.getConfidence() > 0.5;
            }
            catch (e:Error)
            {
            }
            if (detected)
            {
                _markerNode.visible = true;
                _mytitle.visible = true;
                _mymdescription.visible = true;
                _showmodel = true;
                _timer.reset();
                _timer.start();
            }
            _renderer.render();
            return;
        }// end function

        private function changeStatus(event:TimerEvent) : void
        {
            if (_markerNode.visible)
            {
                _markerNode.visible = false;
                _mytitle.visible = false;
                _mymdescription.visible = false;
                _timer.stop();
            }
            trace("Срабатывание таймера");
            return;
        }// end function

        public function set mirror(param1:Boolean) : void
        {
            if (param1)
            {
                _base.scaleX = -1;
                _base.x = 640;
            }
            else
            {
                _base.scaleX = 1;
                _base.x = 0;
            }
            return;
        }// end function

        public function get mirror() : Boolean
        {
            return _base.scaleX < 0;
        }// end function

    }
}
