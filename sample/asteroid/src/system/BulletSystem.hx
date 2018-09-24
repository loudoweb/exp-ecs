package system;

import component.*;
import ecs.node.*;
import ecs.system.*;

using tink.CoreApi;

class BulletSystem extends System {
	@:nodes var nodes:Node<Bullet>;
	
	override function update(dt:Float) {
		for(node in nodes) {
			node.bullet.lifetime -= dt;
			if(node.bullet.lifetime < 0)
				engine.removeEntity(node.entity);
		}
	}
}