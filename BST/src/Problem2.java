import java.util.Stack;

public class Problem2 {

    public static void postOrderTraversalWithLoop(Node root) {
        if (root == null) {
            return;
        }

        Node n = root;
        Stack<Node> stack = new Stack<Node>();
        stack.push(root);

        while (stack.size() > 0) {

            if (n.left != null) {
                n = n.left;
                stack.push(n);
                continue;
            }

            if (n.right != null) {
                n = n.right;
                stack.push(n);
                continue;
            }

            Node parent = stack.pop();

            if(parent != null){
                System.out.println(parent.val);
                if(parent.right != null && parent.right != n){
                    n = parent.right;
                    stack.push(n);
                }
            }
        }
    }

    public static void main(String[] args) {

        // Image
        // http://www.cs.cmu.edu/~adamchik/15-121/lectures/Trees/pix/insertEx.bmp

        Node a = new Node(11);

        Node b = new Node(6);
        Node c = new Node(4);
        Node d = new Node(8);
        Node e = new Node(5);
        Node k = new Node(10);

        Node f = new Node(19);
        Node g = new Node(17);
        Node h = new Node(43);
        Node i = new Node(31);
        Node j = new Node(49);

        // left
        a.left = b;
        b.left = c;
        b.right = d;
        c.right = e;
        d.right = k;

        // right
        a.right = f;
        f.left = g;
        f.right = h;
        h.left = i;
        h.right = j;

        postOrderTraversalWithLoop(a);
    }
}
