Elm.Main = Elm.Main || {};
Elm.Main.make = function (_elm) {
   "use strict";
   _elm.Main = _elm.Main || {};
   if (_elm.Main.values)
   return _elm.Main.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "Main",
   $Basics = Elm.Basics.make(_elm),
   $Color = Elm.Color.make(_elm),
   $Debug = Elm.Debug.make(_elm),
   $Graphics$Collage = Elm.Graphics.Collage.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $Keyboard = Elm.Keyboard.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $Time = Elm.Time.make(_elm);
   var times = F2(function (_v0,
   s) {
      return function () {
         switch (_v0.ctor)
         {case "_Tuple2":
            return {ctor: "_Tuple2"
                   ,_0: _v0._0 * s
                   ,_1: _v0._1 * s};}
         _E.Case($moduleName,
         "on line 33, column 18 to 26");
      }();
   });
   var plus = F2(function (_v4,
   _v5) {
      return function () {
         switch (_v5.ctor)
         {case "_Tuple2":
            return function () {
                 switch (_v4.ctor)
                 {case "_Tuple2":
                    return {ctor: "_Tuple2"
                           ,_0: _v4._0 + _v5._0
                           ,_1: _v4._1 + _v5._1};}
                 _E.Case($moduleName,
                 "on line 32, column 25 to 36");
              }();}
         _E.Case($moduleName,
         "on line 32, column 25 to 36");
      }();
   });
   var updatePos = F2(function (mv,
   pos) {
      return function () {
         switch (mv.ctor)
         {case "Down": return pos - 8;
            case "Still": return pos;
            case "Up": return pos + 8;}
         _E.Case($moduleName,
         "between lines 27 and 30");
      }();
   });
   var position = A2($Signal.foldp,
   updatePos,
   0);
   var Still = {ctor: "Still"};
   var Down = {ctor: "Down"};
   var Up = {ctor: "Up"};
   var movement = function (_v13) {
      return function () {
         return _U.eq(_v13.y,
         1) ? Up : _U.eq(_v13.y,
         -1) ? Down : Still;
      }();
   };
   var ponyMove = function (inputs) {
      return A2($Signal._op["<~"],
      movement,
      A2($Signal.sampleOn,
      $Time.fps(60),
      inputs));
   };
   var lunaPos = position(ponyMove($Keyboard.wasd));
   var celestiaPos = position(ponyMove($Keyboard.arrows));
   var ponyPos = A2($Signal._op["~"],
   A2($Signal._op["<~"],
   F2(function (v0,v1) {
      return {ctor: "_Tuple2"
             ,_0: v0
             ,_1: v1};
   }),
   lunaPos),
   celestiaPos);
   var ballsize = 30;
   var ball = function (pos) {
      return $Graphics$Collage.move(pos)($Graphics$Collage.gradient(A5($Color.radial,
      {ctor: "_Tuple2",_0: 10,_1: 10},
      0,
      {ctor: "_Tuple2",_0: 0,_1: 20},
      50,
      _L.fromArray([{ctor: "_Tuple2"
                    ,_0: 0
                    ,_1: $Color.red}
                   ,{ctor: "_Tuple2"
                    ,_0: 0.8
                    ,_1: $Color.blue}])))($Graphics$Collage.circle(ballsize)));
   };
   var dim = {_: {}
             ,x: 1000
             ,y: 800};
   var bounds = {_: {}
                ,xh: $Basics.toFloat(dim.x) / 2
                ,yh: $Basics.toFloat(dim.y) / 2};
   var luna = function (y) {
      return $Graphics$Collage.move({ctor: "_Tuple2"
                                    ,_0: 0 - bounds.xh + 50
                                    ,_1: y})($Graphics$Collage.toForm(A3($Graphics$Element.image,
      100,
      100,
      "img/luna_400.png")));
   };
   var celestia = function (y) {
      return $Graphics$Collage.move({ctor: "_Tuple2"
                                    ,_0: bounds.xh - 50
                                    ,_1: y})($Graphics$Collage.toForm(A3($Graphics$Element.image,
      100,
      100,
      "img/celestia_400.png")));
   };
   var checkBounds = function (ball) {
      return _U.cmp($Basics.snd(ball.pos) + ballsize / 2,
      bounds.yh) > -1 || _U.cmp($Basics.snd(ball.pos) - ballsize / 2,
      0 - bounds.yh) < 1 ? _U.replace([["direction"
                                       ,0 - ball.direction]],
      ball) : ball;
   };
   var checkPonies = F2(function (_v15,
   ball) {
      return function () {
         switch (_v15.ctor)
         {case "_Tuple2":
            return function () {
                 var $ = ball.pos,
                 ballX = $._0,
                 ballY = $._1;
                 var isReflected = function (_v19) {
                    return function () {
                       switch (_v19.ctor)
                       {case "_Tuple2":
                          return _U.cmp(ballY,
                            _v19._0) < 1 && _U.cmp(ballY,
                            _v19._1) > -1;}
                       _E.Case($moduleName,
                       "on line 48, column 36 to 69");
                    }();
                 };
                 var celestiaTopBottom = {ctor: "_Tuple2"
                                         ,_0: _v15._1 + 50
                                         ,_1: _v15._1 - 50};
                 var celestiaBound = bounds.xh - 100;
                 var lunaTopBottom = {ctor: "_Tuple2"
                                     ,_0: _v15._0 + 50
                                     ,_1: _v15._0 - 50};
                 var lunaBound = 0 - bounds.xh + 100;
                 return _U.cmp(ballX,
                 lunaBound) < 1 && isReflected(lunaTopBottom) || _U.cmp(ballX,
                 celestiaBound) > -1 && isReflected(celestiaTopBottom) ? _U.replace([["direction"
                                                                                     ,$Basics.pi - ball.direction]],
                 ball) : ball;
              }();}
         _E.Case($moduleName,
         "between lines 43 and 52");
      }();
   });
   var checkReset = function (ball) {
      return function () {
         var $ = ball.pos,
         x = $._0,
         y = $._1;
         return _U.cmp(x,
         0 - bounds.xh) < 0 || _U.cmp(x,
         bounds.xh) > 0 ? {_: {}
                          ,direction: 0 - ($Basics.pi - ball.direction)
                          ,pos: {ctor: "_Tuple2"
                                ,_0: 0
                                ,_1: 0}} : ball;
      }();
   };
   var updateBall = F2(function (ponies,
   ball) {
      return function () {
         var ball1 = checkBounds(ball);
         var ball2 = A2(checkPonies,
         ponies,
         ball1);
         var $ = checkReset(ball2),
         pos = $.pos,
         direction = $.direction;
         var pos1 = plus(pos)(A2(times,
         {ctor: "_Tuple2"
         ,_0: $Basics.cos(direction)
         ,_1: $Basics.sin(direction)},
         5));
         return {_: {}
                ,direction: direction
                ,pos: pos1};
      }();
   });
   var ballState = A3($Signal.foldp,
   updateBall,
   {_: {}
   ,direction: 0.4
   ,pos: {ctor: "_Tuple2"
         ,_0: 0
         ,_1: 0}},
   ponyPos);
   var ballPos = A2($Signal._op["<~"],
   function (_) {
      return _.pos;
   },
   ballState);
   var watchBall = A2($Signal._op["<~"],
   $Debug.watch("ball"),
   ballState);
   var scene = F3(function (lunaY,
   celestiaY,
   ballXY) {
      return A3($Graphics$Collage.collage,
      dim.x,
      dim.y,
      _L.fromArray([luna(lunaY)
                   ,celestia(celestiaY)
                   ,ball(ballXY)]));
   });
   var main = A2($Signal._op["~"],
   A2($Signal._op["~"],
   A2($Signal._op["<~"],
   scene,
   lunaPos),
   celestiaPos),
   ballPos);
   var Ball = F2(function (a,b) {
      return {_: {}
             ,direction: b
             ,pos: a};
   });
   _elm.Main.values = {_op: _op
                      ,Ball: Ball
                      ,dim: dim
                      ,bounds: bounds
                      ,ballsize: ballsize
                      ,luna: luna
                      ,celestia: celestia
                      ,ball: ball
                      ,scene: scene
                      ,Up: Up
                      ,Down: Down
                      ,Still: Still
                      ,movement: movement
                      ,updatePos: updatePos
                      ,plus: plus
                      ,times: times
                      ,checkBounds: checkBounds
                      ,checkPonies: checkPonies
                      ,checkReset: checkReset
                      ,updateBall: updateBall
                      ,ponyMove: ponyMove
                      ,position: position
                      ,lunaPos: lunaPos
                      ,celestiaPos: celestiaPos
                      ,ponyPos: ponyPos
                      ,ballState: ballState
                      ,ballPos: ballPos
                      ,main: main
                      ,watchBall: watchBall};
   return _elm.Main.values;
};