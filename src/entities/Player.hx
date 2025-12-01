package entities;

import h2d.Graphics;

class Player {
    public var gridX:Int;
    public var gridY:Int;
    public var hp:Int;
    public var maxHp:Int;
    public var gold:Int;
    public var sprite:Graphics;

    public function new() {
        gridX = 1;
        gridY = 1;
        maxHp = 100;
        hp = 100;
        gold = 0;
    }
}