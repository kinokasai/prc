# Engine

From the point of view of Javacript developer, the usage
of compiled code is very straight forward.

Let's continue on our moving point example.

A new point is created by calling the node's constructor and reset method.
\code
var point_node = new point().reset();
\end_code

Access to equation variables are done through getters and setters.

\code
draw_rect(point_node.get_x(), point_node.get_y(), 20, 20);
\end_code

Finally, calculations are done by calling the corresponding event method.
Event methods have been created from the interface type.

\code
function keyPressHandler(e) {
    dir = e.keyCode;
    switch (dir) {
        case 39:
            point_node.move(dir_enum.Right)
            break;
        case 37:
            point_node.move(dir_enum.Left)
            break;
        case 38:
            point_node.move(dir_enum.Up)
            break;
        case 40:
            point_node.move(dir_enum.Down)
            break;
    }
}
\end_code