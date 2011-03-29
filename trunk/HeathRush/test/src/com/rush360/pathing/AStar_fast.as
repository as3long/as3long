package com.rush360.pathing 
{
/**
 * ...
 * @author sliz http://game-develop.net/blog/
 */
class AStar {
    //private var _open:Array;
    private var _open:BinaryHeap;
    private var _grid:Grid;
    private var _endNode:Node;
    private var _startNode:Node;
    private var _path:Array;
    public var heuristic:Function;
    private var _straightCost:Number = 1.0;
    private var _diagCost:Number = Math.SQRT2;
    private var nowversion:int = 1;

    public function AStar(grid:Grid){
        this._grid = grid;
        heuristic = euclidian2;

    }

    private function justMin(x:Object, y:Object):Boolean {
        return x.f < y.f;
    }

    public function findPath():Boolean {
        _endNode = _grid.endNode;
        nowversion++;
        _startNode = _grid.startNode;
        //_open = [];
        _open = new BinaryHeap(justMin);
        _startNode.g = 0;
        return search();
    }

    public function search():Boolean {
        var node:Node = _startNode;
        node.version = nowversion;
        while (node != _endNode){
            var len:int = node.links.length;
            for (var i:int = 0; i < len; i++){
                var test:Node = node.links[i].node;
                var cost:Number = node.links[i].cost;
                var g:Number = node.g + cost;
                var h:Number = heuristic(test);
                var f:Number = g + h;
                if (test.version == nowversion){
                    if (test.f > f){
                        test.f = f;
                        test.g = g;
                        test.h = h;
                        test.parent = node;
                    }
                } else {
                    test.f = f;
                    test.g = g;
                    test.h = h;
                    test.parent = node;
                    _open.ins(test);
                    test.version = nowversion;
                }

            }
            if (_open.a.length == 1){
                return false;
            }
            node = _open.pop() as Node;
        }
        buildPath();
        return true;
    }

    private function buildPath():void {
        _path = [];
        var node:Node = _endNode;
        _path.push(node);
        while (node != _startNode){
            node = node.parent;
            _path.unshift(node);
        }
    }

    public function get path():Array {
        return _path;
    }

    public function manhattan(node:Node):Number {
        return Math.abs(node.x - _endNode.x) + Math.abs(node.y - _endNode.y);
    }

    public function manhattan2(node:Node):Number {
        var dx:Number = Math.abs(node.x - _endNode.x);
        var dy:Number = Math.abs(node.y - _endNode.y);
        return dx + dy + Math.abs(dx - dy) / 1000;
    }

    public function euclidian(node:Node):Number {
        var dx:Number = node.x - _endNode.x;
        var dy:Number = node.y - _endNode.y;
        return Math.sqrt(dx * dx + dy * dy);
    }

    private var TwoOneTwoZero:Number = 2 * Math.cos(Math.PI / 3);

    public function chineseCheckersEuclidian2(node:Node):Number {
        var y:int = node.y / TwoOneTwoZero;
        var x:int = node.x + node.y / 2;
        var dx:Number = x - _endNode.x - _endNode.y / 2;
        var dy:Number = y - _endNode.y / TwoOneTwoZero;
        return sqrt(dx * dx + dy * dy);
    }

    private function sqrt(x:Number):Number {
        return Math.sqrt(x);
    }

    public function euclidian2(node:Node):Number {
        var dx:Number = node.x - _endNode.x;
        var dy:Number = node.y - _endNode.y;
        return dx * dx + dy * dy;
    }

    public function diagonal(node:Node):Number {
        var dx:Number = Math.abs(node.x - _endNode.x);
        var dy:Number = Math.abs(node.y - _endNode.y);
        var diag:Number = Math.min(dx, dy);
        var straight:Number = dx + dy;
        return _diagCost * diag + _straightCost * (straight - 2 * diag);
    }
}

class Grid {

    private var _startNode:Node;
    private var _endNode:Node;
    private var _nodes:Array;
    private var _numCols:int;
    private var _numRows:int;

    private var type:int;

    private var _straightCost:Number = 1.0;
    private var _diagCost:Number = Math.SQRT2;

    public function Grid(numCols:int, numRows:int){
        _numCols = numCols;
        _numRows = numRows;
        _nodes = new Array();

        for (var i:int = 0; i < _numCols; i++){
            _nodes[i] = new Array();
            for (var j:int = 0; j < _numRows; j++){
                _nodes[i][j] = new Node(i, j);
            }
        }
    }

    /**
     *
     * @param    type    0四方向 1八方向 2跳棋
     */
    public function calculateLinks(type:int = 0):void {
        this.type = type;
        for (var i:int = 0; i < _numCols; i++){
            for (var j:int = 0; j < _numRows; j++){
                initNodeLink(_nodes[i][j], type);
            }
        }
    }

    public function getType():int {
        return type;
    }

    /**
     *
     * @param    node
     * @param    type    0八方向 1四方向 2跳棋
     */
    private function initNodeLink(node:Node, type:int):void {
        var startX:int = Math.max(0, node.x - 1);
        var endX:int = Math.min(numCols - 1, node.x + 1);
        var startY:int = Math.max(0, node.y - 1);
        var endY:int = Math.min(numRows - 1, node.y + 1);
        node.links = [];
        for (var i:int = startX; i <= endX; i++){
            for (var j:int = startY; j <= endY; j++){
                var test:Node = getNode(i, j);
                if (test == node || !test.walkable){
                    continue;
                }
                if (type != 2 && i != node.x && j != node.y){
                    var test2:Node = getNode(node.x, j);
                    if (!test2.walkable){
                        continue;
                    }
                    test2 = getNode(i, node.y);
                    if (!test2.walkable){
                        continue;
                    }
                }
                var cost:Number = _straightCost;
                if (!((node.x == test.x) || (node.y == test.y))){
                    if (type == 1){
                        continue;
                    }
                    if (type == 2 && (node.x - test.x) * (node.y - test.y) == 1){
                        continue;
                    }
                    if (type == 2){
                        cost = _straightCost;
                    } else {
                        cost = _diagCost;
                    }
                }
                node.links.push(new Link(test, cost));
            }
        }
    }

    public function getNode(x:int, y:int):Node {
        return _nodes[x][y];
    }

    public function setEndNode(x:int, y:int):void {
        _endNode = _nodes[x][y];
    }

    public function setStartNode(x:int, y:int):void {
        _startNode = _nodes[x][y];
    }

    public function setWalkable(x:int, y:int, value:Boolean):void {
        _nodes[x][y].walkable = value;
    }

    public function get endNode():Node {
        return _endNode;
    }

    public function get numCols():int {
        return _numCols;
    }

    public function get numRows():int {
        return _numRows;
    }

    public function get startNode():Node {
        return _startNode;
    }

}

class Link {
    public var node:Node;
    public var cost:Number;

    public function Link(node:Node, cost:Number){
        this.node = node;
        this.cost = cost;
    }

}

class BinaryHeap {
    public var a:Array = [];
    public var justMinFun:Function = function(x:Object, y:Object):Boolean {
        return x < y;
    };

    public function BinaryHeap(justMinFun:Function = null){
        a.push(-1);
        if (justMinFun != null)
            this.justMinFun = justMinFun;
    }

    public function ins(value:Object):void {
        var p:int = a.length;
        a[p] = value;
        var pp:int = p >> 1;
        while (p > 1 && justMinFun(a[p], a[pp])){
            var temp:Object = a[p];
            a[p] = a[pp];
            a[pp] = temp;
            p = pp;
            pp = p >> 1;
        }
    }

    public function pop():Object {
        var min:Object = a[1];
        a[1] = a[a.length - 1];
        a.pop();
        var p:int = 1;
        var l:int = a.length;
        var sp1:int = p << 1;
        var sp2:int = sp1 + 1;
        while (sp1 < l){
            if (sp2 < l){
                var minp:int = justMinFun(a[sp2], a[sp1]) ? sp2 : sp1;
            } else {
                minp = sp1;
            }
            if (justMinFun(a[minp], a[p])){
                var temp:Object = a[p];
                a[p] = a[minp];
                a[minp] = temp;
                p = minp;
                sp1 = p << 1;
                sp2 = sp1 + 1;
            } else {
                break;
            }
        }
        return min;
    }
}

class Node {
    public var x:int;
    public var y:int;
    public var f:Number;
    public var g:Number;
    public var h:Number;
    public var walkable:Boolean = true;
    public var parent:Node;
    //public var costMultiplier:Number = 1.0;
    public var version:int = 1;
    public var links:Array;

    //public var index:int;
    public function Node(x:int, y:int){
        this.x = x;
        this.y = y;
    }
}

}