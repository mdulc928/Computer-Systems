//10/23/2019 - Class 210
template<typename Key> //look into Compare
class BST{
	struct Node{
		Key key;
		Node *left, *right;
		Node(const Key k): key(k), left = nullptr, right = nullptr{;}
	};
	int sizet
	
	Node *root;
	void insert(Node *pos, const Key &key){
		if(root != nullptr & pos == nullptr) {throw ArgumentException();}
		if(empty()){root = Node(key);}
		//pos cannot be a nullptr; so try to see if you can fix this.
		while(true){
			if(key < pos->key){
				//pos is either null or not null
				if(pos->left == nullptr){
					pos->left = new Node(key);
					++sizet;
					return;
				}else{
					pos = pos->left;
				}
				//left.insert(pos)
				
			}else if(pos->key < key){ //it is actually an efficiency thing to use only one operator
				if(pos->right == nullptr){
					pos->right = new Node(key);
				}else{
					pos = pos->right; 
				}
				//right.insert(pos);
			}else{
				return;//since we don't want to handle the possibility of duplicates yet.
			}
		}
	}
	public:
		bool empty() {return (root == nullptr);}
		void insert(const Key &key){
			insert(root, key);
		}
};