module orly.engine.assets.asset;

abstract class Asset {
 private:

	

 public:

	/** Returns true, if this asset type is proper for specific file. */
	abstract bool CanHandle(string filename);

}