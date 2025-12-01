package;

import hxd.App;
import hxd.System;
import ui.Menu;
import game.GameWorld;

class Main extends App {
    
    var menu:Menu;
    var gameWorld:GameWorld;

    override function init() {
        // Initialize basic resources if needed
        // hxd.Res.initLocal(); // Uncomment if using real assets on disk
        
        showMenu();
    }

    public function showMenu() {
        if (gameWorld != null) {
            gameWorld.remove();
            gameWorld = null;
        }
        menu = new Menu(s2d, this);
    }

    public function startGame(isContinue:Bool) {
        if (menu != null) {
            menu.remove();
            menu = null;
        }
        gameWorld = new GameWorld(s2d, this);
        gameWorld.init(isContinue);
    }

    public function exitGame() {
        System.exit();
    }

    static function main() {
        new Main();
    }
}