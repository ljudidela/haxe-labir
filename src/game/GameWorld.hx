package game;

import h2d.Object;
import h2d.Text;
import hxd.Event;
import hxd.Key;
import entities.Player;
import ui.Hud;

class GameWorld extends Object {
    var main:Main;
    var player:Player;
    var hud:Hud;
    var level:Int = 1;
    var map:Array<Array<Int>>;
    var mapWidth = 20;
    var mapHeight = 15;
    var tileSize = 32;
    var mapContainer:Object;
    
    // Game State
    var turn:Int = 0;
    var messageLog:Array<String> = [];
    var storyShown:Bool = false;
    var storyText:Text;

    public function new(parent:Object, main:Main) {
        super(parent);
        this.main = main;
    }

    public function init(isContinue:Bool) {
        if (isContinue) {
            level = 5; // Mock continue
            log("Game Loaded. Welcome back to floor " + level);
        } else {
            level = 1;
            log("Welcome to the Fatal Labyrinth.");
        }

        mapContainer = new Object(this);
        mapContainer.x = 50;
        mapContainer.y = 50;

        player = new Player();
        hud = new Hud(this, player);

        generateLevel();
        
        if (!isContinue) showStory();
        else getScene().addEventListener(onEvent);
    }

    function showStory() {
        storyShown = true;
        var bg = new h2d.Graphics(this);
        bg.beginFill(0x000000, 0.9);
        bg.drawRect(0, 0, getScene().width, getScene().height);
        
        storyText = new Text(hxd.res.DefaultFont.get(), this);
        storyText.text = "Year 2025...
The Dragon of Chaos has stolen the Source Code.
You must descend into the Labyrinth to retrieve it.

Press ENTER to enter the dungeon.";
        storyText.scale(2);
        storyText.textAlign = Center;
        storyText.x = getScene().width / 2;
        storyText.y = getScene().height / 2 - 100;

        getScene().addEventListener(onStoryInput);
    }

    function onStoryInput(e:Event) {
        if (e.kind == EKeyDown && e.keyCode == Key.ENTER) {
            getScene().removeEventListener(onStoryInput);
            storyText.remove();
            storyShown = false;
            getScene().addEventListener(onEvent);
            drawMap(); // Redraw to clear overlay if needed
        }
    }

    function generateLevel() {
        map = [];
        for (y in 0...mapHeight) {
            var row = [];
            for (x in 0...mapWidth) {
                // Simple box with random pillars
                if (x == 0 || x == mapWidth - 1 || y == 0 || y == mapHeight - 1) {
                    row.push(1); // Wall
                } else if (Math.random() < 0.1) {
                    row.push(1); // Random Wall
                } else {
                    row.push(0); // Floor
                }
            }
            map.push(row);
        }
        
        // Place Stairs
        map[mapHeight-2][mapWidth-2] = 2;

        // Reset Player Pos
        player.gridX = 1;
        player.gridY = 1;
        
        drawMap();
        hud.updateStats(level);
    }

    function drawMap() {
        mapContainer.removeChildren();
        for (y in 0...mapHeight) {
            for (x in 0...mapWidth) {
                var tile = new h2d.Graphics(mapContainer);
                tile.x = x * tileSize;
                tile.y = y * tileSize;
                
                switch(map[y][x]) {
                    case 1: // Wall
                        tile.beginFill(0x555555);
                        tile.drawRect(0, 0, tileSize, tileSize);
                    case 2: // Stairs
                        tile.beginFill(0x0000FF);
                        tile.drawRect(4, 4, tileSize-8, tileSize-8);
                    default: // Floor
                        tile.beginFill(0x222222);
                        tile.drawRect(1, 1, tileSize-2, tileSize-2);
                }
            }
        }
        
        // Draw Player
        var p = new h2d.Graphics(mapContainer);
        p.beginFill(0x00FF00);
        p.drawCircle(tileSize/2, tileSize/2, tileSize/3);
        p.x = player.gridX * tileSize;
        p.y = player.gridY * tileSize;
        player.sprite = p;
    }

    function onEvent(e:Event) {
        if (storyShown) return;
        if (e.kind == EKeyDown) {
            var dx = 0;
            var dy = 0;
            switch(e.keyCode) {
                case Key.UP: dy = -1;
                case Key.DOWN: dy = 1;
                case Key.LEFT: dx = -1;
                case Key.RIGHT: dx = 1;
                case Key.ESCAPE: 
                    getScene().removeEventListener(onEvent);
                    main.showMenu();
                    return;
            }

            if (dx != 0 || dy != 0) {
                movePlayer(dx, dy);
            }
        }
    }

    function movePlayer(dx:Int, dy:Int) {
        var tx = player.gridX + dx;
        var ty = player.gridY + dy;

        if (tx >= 0 && tx < mapWidth && ty >= 0 && ty < mapHeight) {
            var tile = map[ty][tx];
            if (tile != 1) { // Not a wall
                player.gridX = tx;
                player.gridY = ty;
                player.sprite.x = tx * tileSize;
                player.sprite.y = ty * tileSize;
                
                if (tile == 2) {
                    nextLevel();
                }
                
                // Random encounter logic could go here
                if (Math.random() < 0.05) {
                    player.hp -= 5;
                    log("You stepped on a trap! -5 HP");
                    if (player.hp <= 0) gameOver();
                }
                
                hud.updateStats(level);
            } else {
                log("Blocked.");
            }
        }
    }

    function nextLevel() {
        level++;
        log("Descending to floor " + level + "...");
        generateLevel();
    }

    function gameOver() {
        log("YOU DIED.");
        getScene().removeEventListener(onEvent);
        var t = new Text(hxd.res.DefaultFont.get(), this);
        t.text = "GAME OVER";
        t.scale(5);
        t.textColor = 0xFF0000;
        t.x = 300;
        t.y = 300;
        
        haxe.Timer.delay(function() {
            main.showMenu();
        }, 3000);
    }

    public function log(msg:String) {
        messageLog.push(msg);
        if (messageLog.length > 5) messageLog.shift();
        hud.updateLog(messageLog);
    }
}