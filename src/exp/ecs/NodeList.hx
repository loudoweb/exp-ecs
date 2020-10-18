package exp.ecs;

import tink.state.Observable;

class NodeList<T> {
	public var length(get, never):Int;

	final query:Query;
	final fetchComponents:Entity->T;
	final list:Observable<Array<Node<T>>>;

	public function new(world:World, query, fetchComponents) {
		this.query = query;
		this.fetchComponents = fetchComponents;
		this.list = {
			final cache = new Map();
			final entities = world.entities.query(query);
			final nodes = Observable.auto(() -> {
				for (entity in entities.value) {
					if (!cache.exists(entity))
						cache.set(entity, Observable.auto(() -> new Node(entity, fetchComponents(entity))));
				}
				cache;
			}, (_, _) -> false);
			Observable.auto(() -> [for (node in nodes.value) node.value]);
		}
	}

	public inline function iterator() {
		return list.value.iterator();
	}

	inline function get_length()
		return list.value.length;

	public static macro function generate(e);
}
