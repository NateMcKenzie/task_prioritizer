# Task Object

- Total time estimate : float (hours) ? Duration?
- Time spent : float (hours) ? Duration?
- Due date : DateTime
- Name : String
- Description : String

# Priority Queue

- I will make my own ~~leftist heap~~ skew heap
    - I changed to a skew heap because dataset will be small enought that is worth saving the effort
- `pop()` : Generic - value of node 
   - Remove root node.
   - Return root value.
   - Merge two sub-trees
- `insert(value : Generic)` : void
   - Create node for value
   - Merge new node into existing tree
- `merge(node1 : node, node2 : node)` : node 
## Node Object
- value : generic
- left : node
- right : node
- npl : int
- `updateNpl()`
    - if one child is null, npl = 0
    - else
    - npl = min of children's npl + 1

# MVP Test screen
- Field for each item in task.
- "Save" button will just add to queue for now.
- "pop" button to display next item off queue
