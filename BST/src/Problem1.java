public class Problem1 {

    public static Node findValueLessThanOrEqualTo(Node n, int max, Node best) {
        if (n == null)
            return best;
        if (n.val == max)
            return n;
        if (n.val > max)
            return findValueLessThanOrEqualTo(n.left, max, best);
        else if (n.right == null)
            return n;

        return findValueLessThanOrEqualTo(n.right, max, n);
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

        Node res = findValueLessThanOrEqualTo(a, 5, null);
        System.out.println(res.val);
    }
}
